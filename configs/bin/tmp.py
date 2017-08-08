import re
import requests
import urllib
from bs4 import BeautifulSoup as bs4

data = "Correct! Yay!\nRound 2: Prove me you're a human!\nName: Dark Knight, Director: ??, Year: 2002\n"
name = re.findall(r"Name: (.*?),", data)[0].strip()
ua = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.110 Safari/537.36'
headers = {
        'User-Agent': ua
}
r = requests.get("https://www.google.co.in/search?q=" + urllib.quote(name) + "+movie", headers=headers)
soup = bs4(r.text.encode('utf-8').replace("<", "\n<").replace(">", ">\n").replace(":", ""), 'html.parser')
soup = soup.find("div", {"class": "g rhsvw kno-kp mnr-c g-blk"})
k = [k for k in soup.get_text().encode('utf-8').split("\n") if k.strip() != ""]

for i, m in enumerate(k):
    if 'Director' in m:
        director = k[i+1]
    elif 'Initial release' in m:
        release = re.findall(r"\d\d\d\d", k[i+1])[0]

if re.findall(r"Director: (.*?),", data)[0].strip() == "??":
    ans = director
elif re.findall(r"Year: (.*)", data)[0].strip() == "??":
    ans = release
else:
    print "I didn't understand the question"
    exit(1)

print ans
