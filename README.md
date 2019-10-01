# web_scraping_with_R

- R을 이용한 웹 스크래핑 연습을 하고 있습니다. 연습한 결과물을 공유합니다.
- 정갈하지 못 한 코드이니 감안하시길 바랍니다.


### **1_climate_watch_data_org.R**

- 첫번째 연습대상인 **www.climatewatchdata.org**는 url 주소가 비교적 복잡하고 웹페이지가 java 스크립트로 구성되어 있어서 여러가지로 많은 공부가 되었다.
- Rselenium으로 웹페이지를 읽고 rvest로 태그를 취합하는 방식으로 sectoral-information에 해당하는 목록을 가져오는 코드를 작성했다.
- <https://www.climatewatchdata.org/ndcs/country/IND/sectoral-information>



### **2_연도별청소년정책성과.R**

- 청소년정책분석평가센터에서는 연도별 [청소년정책성과](http://www.ypec.re.kr/modedg/contentsView.do?ucont_id=CTX000007&srch_menu_nix=t7W3a9w7)를 공개하고 있다. 
- 웹페이지 내부에 이미 마련되어 있는 17개 시도별 결과표 중에서, 사용자가 지도 위에 마우스를 올리면 해당지역의 점수만 따로따로 공개하는 구조인데 일괄적으로 정리되어 있지 않아 정책성과를 한눈에 파악하기 어려운 부분이 있다. 
- rvest의 html_table()을 이용하여 17개 시도의 성과표를 전부 가져온 후, 원점수와 z.score를 분리하는 과정을 거쳐 표 하나로 정리하였다. 