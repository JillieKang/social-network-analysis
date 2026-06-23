# Requiremnets
library(curl)
library(RSelenium)

# Make url to crawl 
base_url <- "https://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page="
search_type <- "&search_type=sub_memo"
middle_url <- "&keyword="
keyword <- "권영국"
first_page <- 1
end_page <- 8

print(length(URL))
print(class(URL))
print(URL)
encoded_keyword <- URLencode(keyword)
# https://www.ppomppu.co.kr/zboard/zboard.php?id=issue&page_num=30&category=&search_type=sub_memo&keyword=
# https://www.ppomppu.co.kr/zboard/zboard.php?id=freeboard&page=1&search_type=sub_memo&keyword=%B1%C7%BF%B5%B1%B9&divpage=1759

# Web crawling using chrome driver
remDr <- remoteDriver(remoteServerAddr="localhost",  
                      port=4445L,  
                      browserName="chrome") 

# Open the browser
remDr$open()

# Crawling
if (TRUE){
  
  # `scrap_vec_of_post_for_()`: collecting lists of posts by page 
  vec_of_post_info_result <- data.frame() 
  for(page_num in first_page:end_page){
    char_page_num <- as.character(page_num)      
    URL <- paste(base_url, page_num, search_type, middle_url,
                 URLencode(keyword),    
                 # `URLencode()`: converting characters hexadecimals 
                 sep = "")
    remDr$navigate(URL) # `navigate()`: connecting to the url
    Sys.sleep(0.2)        # 0.2 secs of break
    
    # `getPageSource()`: get HTML sources of the current page 
    페이지html <- remDr$getPageSource()[[1]] %>% read_html()
    
    # `scrap_vec_of_post_for_()`: get lists of the post 
    one_page_df <- scrap_vec_of_post_for_(하나_페이지html = 페이지html)
    
    # Merge them into the data frame
    vec_of_post_info_result <- rbind(vec_of_post_info_result, one_page_df)
  }  
  # Remove duplicates
  vec_of_post_info_result <- vec_of_post_info_result[!duplicated(vec_of_post_info_result$게시글id),]
  
  # Make a data frame for details of each post
  post_detail_info_result <- data.frame() 
  # Make a data frame for comments
  comment_info_result <- data.frame()    
  
  # Collect details of each post
  start_index <- 143 
  for(index in start_index:nrow(vec_of_post_info_result)){
    
    # Access to each post
    게시글url <- vec_of_post_info_result[index, "게시글url"]
    remDr$navigate(게시글url)
    Sys.sleep(0.2) # 대기
    
    # Get HTML sources of the current post
    게시글html <- remDr$getPageSource()[[1]] %>% read_html()
    
    # Collect the id of each post
    게시글id <- vec_of_post_info_result[index, "게시글id"]
    
    # `get_post_detail_info()`: Collect the detail of each post based on the list of posts
    one_post_detail_info <- get_post_detail_info(게시글html_ = 게시글html, 게시글id_ = 게시글id)
    cat(index, "번째 ", 게시글id, "게시글의 세부정보 수집완료 \n")
    post_detail_info_result <- rbind(post_detail_info_result, one_post_detail_info)
    
    # `get_all_of_comment_df()`: Collect comments of each post
    all_of_comment_df <- get_all_of_comment_df(게시글html_ = 게시글html, 게시글id_ = 게시글id)
    cat(index, "번째 ", 게시글id, "게시글의 댓글 수집완료 \n")
    comment_info_result <- rbind(comment_info_result, all_of_comment_df)
    
  }
  
}

# Cut off the data collected based on the page number by date
# Cut off on Apr 14 2025
View(vec_of_post_info_result)
vec_of_post_info_result <- vec_of_post_info_result[1:147, ]

View(post_detail_info_result)
post_detail_info_result <- post_detail_info_result[1:147, ]

View(comment_info_result)
comment_info_result <- comment_info_result[1:1019,]


# Save them as .xlsx
write.xlsx(vec_of_post_info_result, '게시글목록(권영국).xlsx')
write.xlsx(post_detail_info_result, '게시글세부정보목록(권영국).xlsx')
write.xlsx(comment_info_result, '댓글목록(권영국).xlsx')

# If the volume of the text is too large for .xlsx, use .csv instead
# write.csv(post_detail_info_result, "./게시글세부정보목록(검색어).csv") 
# Using CP949 as an encoding method is recommended



