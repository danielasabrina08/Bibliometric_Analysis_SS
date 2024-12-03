from config import CREDENTIALS

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from time import sleep
import random



opts = Options()

driver = webdriver.Chrome(
    service=Service(ChromeDriverManager().install()),
    options=opts
)

# Abrir la página Web of Science
driver.get('https://www.webofscience.com/wos/woscc/summary/b7416c1b-0549-4180-bca8-3a8f19572aa7-d8fd0184/relevance/1')
sleep(random.randint(5, 8))
driver.find_element('id', 'mat-input-0').send_keys(CREDENTIALS['username'])
driver.find_element('id', 'mat-input-1').send_keys(CREDENTIALS['password'])

driver.find_element('id', "signIn-btn").click()

sleep(10)