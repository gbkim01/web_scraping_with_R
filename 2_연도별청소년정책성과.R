library(rvest)
library(dplyr)


###################  url 취합 및 17시도 테이블 크롤링 ################## 

url_front <- "http://www.ypec.re.kr/modedg/contentsView.do?ucont_id=CTX0000"
url_mid <- c("07", "14")
url_end <- "&srch_menu_nix=t7W3a9w7"

dt_full <- NULL

for (x in 1:length(url_mid)) {
  url <- paste0(url_front, url_mid[x], url_end)
  read_html(url) %>% html_nodes(".title") %>% html_text() -> prob
  read_html(url) %>% html_nodes(".result table") %>% html_table() -> table
  for (i in 1:17) {
    dt <- cbind(2016+x, prob[i], table[[i]])
    names(dt) <- c("평가연도", "지역", "항목", "원점수100", "z.score")
    dt_full <- rbind(dt_full, dt) 
  }
}


###################  테이블 핸들링 짝수행과 홀수행 구분 ################## 

quality <- filter(dt_full, seq_len(nrow(dt_full))%% 2==1)  # 홀수행은 삶의 질
names(quality) <- c("평가연도", "지역", "항목", "삶의질원점수100", "삶의질_Z.score")

actlevel <- filter(dt_full, seq_len(nrow(dt_full))%% 2==0)  # 짝수행은 활동수준
names(actlevel) <- c("평가연도", "지역", "항목", "참여활동원점수100", "참여활동_Z.score")

data <- merge(quality, actlevel, by=c("지역","평가연도"), all=TRUE)
data1 <- data[, -c(3,6)]
data1 <- arrange(data1, 평가연도, 지역)

View(data1)
