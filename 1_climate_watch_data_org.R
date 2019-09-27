library(RSelenium)
library(rvest) #HTML처리
library(stringr) #문자열 함수
library(dplyr)

########### Rselenium 설정 #############

### 포트 열기 : CMD에 입력 
##  cd C:\Selenium
##  java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-3.9.1.jar -port 4445 (버전에 맞게 수정해준다)

remDr <- remoteDriver(remoteServ = 'localhost',
                      port = 4445L, # 포트번호 입력
                      browserName = "chrome") 


remDr$open() # 브라우저 열기


########### Section 취합 #############
### 1. 대문 page 이동
remDr$navigate("https://www.climatewatchdata.org/ndcs/country/IND/sectoral-information?section=none&sector=none") 
## 대문 page source 읽기
html_page <- remDr$getPageSource()[[1]]

### 2. section 주소  : section_link 주소
section <- read_html(html_page) %>% html_nodes("div.accordion-styles__title__2PD3i") %>% html_text() 
section_adr <- str_replace_all(str_to_lower(section), " ", "_") ##대문자 to 소문자, 공백을 "_"로 대체




########### 주소 취합 #############
main <- "https://www.climatewatchdata.org/ndcs/country/IND/sectoral-information?section="
section_sector <- NULL
link_list <- NULL

for (i in 1:length(section_adr)) {
  
  section_link <- paste0(main, section_adr[i], "&sector=none")
  
  ### 3. sector 주소  : sector_link 주소
  remDr$navigate(section_link)
  Sys.sleep(3) # 3초 딜레이
  
  section_page <- remDr$getPageSource()[[1]]
  sector <- read_html(section_page) %>% html_nodes("div.ndcs-country-accordion-styles__subAccordion__1zDx7") %>% html_nodes("div.accordion-styles__title__2PD3i") %>% html_text() 
  
  link_list <- cbind(i, section[i], section_adr[i], sector)
  section_sector <- rbind(section_sector, link_list)
}

section_sector <- data.frame(section_sector)
names(section_sector) <- c("index", "section", "section_adr", "sector")
section_sector$sector_adr <- str_to_lower(section_sector$sector)
section_sector$sector_adr <- str_split_fixed(section_sector$sector_adr, "[|]", 2)[,2]
section_sector$sector_adr <- str_trim(section_sector$sector_adr)
section_sector$sector_adr <- str_replace_all(section_sector$sector_adr, "[-:/ ]", "_")
section_sector$sector_adr <- str_replace_all(section_sector$sector_adr, "__", "_")

### 주소 만들기
link_pool <- NULL
for (i in 1:dim(section_sector)[1]) {
  link <- paste0(main, section_sector$section_adr[i], "&sector=", section_sector$sector_adr[i])
  link_pool <- append(link_pool, link)
}

section_sector <- cbind(section_sector, link_pool)


########### 자료 취합 #############

data <- NULL

for (i in 1:dim(section_sector)[1]) {
  
  remDr$navigate(section_sector$link_pool[i])
  Sys.sleep(3) # 3초 딜레이
  
  page <- remDr$getPageSource()[[1]]
  read_html(page) %>% html_nodes(".definition-list-styles__definitionTitle__-v25q")  %>% html_text() -> contents
  read_html(page) %>% html_nodes(".definition-list-styles__definitionDesc__1Ong6")  %>% html_text() -> numbers
  
  list <- data.frame(section_sector$section[i], section_sector$sector[i], contents, numbers)
  data <- rbind(data, list)
  
}

head(data, 20)

remDr$close() # 브라우저 닫기

write.csv(data, file = "./output/india_sectoral_information.csv")