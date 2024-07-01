from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
from time import sleep

opts = Options()

driver = webdriver.Chrome(
    service=Service(ChromeDriverManager().install()),
    options=opts
)

# Abrir la página Web of Science
driver.get('https://www.webofscience.com/wos/woscc/summary/b7416c1b-0549-4180-bca8-3a8f19572aa7-d8fd0184/relevance/1')

# Mantener abierto durante algunos segundos
sleep(10)