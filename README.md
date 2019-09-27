# web_scraping_with_R

- R을 이용한 웹 스크래핑 연습을 하고 있습니다. 연습한 결과물을 공유합니다.
- 정갈하지 못 한 코드이니 감안하시길 바랍니다.


### **1_climate_watch_data_org.R**

- 첫번째 연습대상인 __www.climatewatchdata.org__는 url 주소가 비교적 복잡하고 웹페이지가 java 스크립트로 구성되어 있어서 여러가지로 많은 공부가 되었습니다.
- Rselenium으로 웹페이지를 읽고 rvest로 태그를 취합하는 방식으로 sectoral-information에 해당하는 목록을 가져오는 코드를 작성했습니다.
- <https://www.climatewatchdata.org/ndcs/country/IND/sectoral-information>
