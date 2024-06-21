import os
import requests
from bs4 import BeautifulSoup
import sqlite3

def delete_database():
    if os.path.exists('ads.db'):
        os.remove('ads.db')

def create_database():
    conn = sqlite3.connect('ads.db')
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS queries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            query TEXT
        )
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS ads (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT,
            position TEXT,
            site_url TEXT,
            title TEXT,
            query_id INTEGER,
            FOREIGN KEY (query_id) REFERENCES queries (id)
        )
    ''')
    conn.commit()
    conn.close()

# def save_query_to_database(query):
#     conn = sqlite3.connect('ads.db')
#     cursor = conn.cursor()
#     cursor.execute('''
#         INSERT INTO queries (query) VALUES (?)
#     ''', (query,))
#     query_id = cursor.lastrowid
#     conn.commit()
#     conn.close()
#     return query_id

def save_ads_to_database(results, query_id):
    conn = sqlite3.connect('ads.db')
    cursor = conn.cursor()
    cursor.executemany('''
        INSERT INTO ads (url, position, site_url, title, query_id) VALUES (?, ?, ?, ?, ?)
    ''', [(ad['url'], ad['position'], ad['site_url'], ad['title'], query_id) for ad in results])
    conn.commit()
    conn.close()

def fetch_page_details(url):
    try:
        response = requests.get(url)
        soup = BeautifulSoup(response.text, 'html.parser')
        site_url = response.url
        title = soup.title.string if soup.title else 'No title found'
    except requests.RequestException:
        site_url = 'Could not fetch site'
        title = 'Could not fetch title'
    return site_url, title

def fetch_ads_from_google(query):
    url = 'https://www.google.com/search'
    params = {'q': query}
    response = requests.get(url, params=params)
    soup = BeautifulSoup(response.text, 'html.parser')
    ads = soup.findAll('div', attrs={'class': 'uEierd'})

    results = []
    for index, ad in enumerate(ads):
        link = ad.find('a', href=True)
        url = link['href'] if link else 'No URL found'
        position = 'вверху' if index < len(ads)/2 else 'внизу'
        site_url, title = fetch_page_details(url)
        results.append({'url': url, 'position': position, 'site_url': site_url, 'title': title})

    return results

# Удаляем старую базу данных (если есть) и создаем новую
# delete_database()
# create_database()

# Список поисковых запросов
# queries = ['ремонт ноутбука харьков', 'купить смартфон Киев', 'магазины электроники Москва']
cursor = sqlite3.connect('ads.db').cursor()
queries = cursor.execute('SELECT query FROM queries').fetchall()
q_ids = cursor.execute('SELECT id FROM queries').fetchall()
# Получаем объявления для каждого запроса и сохраняем их в базу данных
for query in queries:
    # query_id = save_query_to_database(query)
    ads_info = fetch_ads_from_google(query)
    # query_id = cursor.execute('SELECT id FROM queries WHERE query = query', (query,)).fetchone()[0]
    save_ads_to_database(ads_info, q_ids[queries.index(query)][0])
    # Печатаем результаты для каждого запроса
    for ad in ads_info:
        print(ad)

# Дополнительно можно сделать функцию для чтения данных из базы и их вывода
def fetch_from_database():
    conn = sqlite3.connect('ads.db')
    cursor = conn.cursor()
    cursor.execute('''
        SELECT ads.id, ads.url, ads.position, ads.site_url, ads.title, queries.query 
        FROM ads 
        JOIN queries ON ads.query_id = queries.id
    ''')
    ads = cursor.fetchall()
    conn.close()
    return ads

# Печатаем данные, сохраненные в базе
stored_ads = fetch_from_database()
for ad in stored_ads:
    print(ad)
