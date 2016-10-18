# data objects required for all functions
Huglin.index <- readRDS("./data/Huglin_index.rds")
Huglin.index.new <- readRDS("./data/Huglin_index_new.rds")
Max.Year <- max(as.numeric(unlist(Huglin.index[, 1])), na.rm =  TRUE)
Min.Year <- min(as.numeric(unlist(Huglin.index[, 1])), na.rm =  TRUE)

mycss <- "
#plot-container {
position: relative;
}
#loading-spinner {
position: absolute;
left: 50%;
top: 50%;
z-index: -1;
margin-top: -33px;  /* half of the spinner's height */
margin-left: -33px; /* half of the spinner's width */
}
#plot.recalculating {
z-index: -2;
"