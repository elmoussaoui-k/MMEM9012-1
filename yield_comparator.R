#|--------------------------------------------------------|#
#| DNA EXTRACTION YIELD COMPARATOR : statistical analysis |#
#|--------------------------------------------------------|#

##### PART. I : PACKAGE MANAGEMENT #####
# 1.1. Install required extra packages
install.packages("viridis")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("cowplot")
install.packages("gridExtra")
install.packages("gmodels")
install.packages("moments")
install.packages("rstatix")
install.packages("KefiR")

# 1.2. Loading required extra packages
library(dplyr)
library(ggplot2)
library(viridis)
library(cowplot)
library(gridExtra)
library(moments)
library(gmodels)
library(rstatix)
library(KefiR)


##### PART. II : PRESETS #####
# 2.1. Data input
source <- "Centre national de référence mycoses"
dataset_1 <- "dna_extraction_raw_data.csv"
extraction_data <- read.csv(dataset_1, stringsAsFactors = FALSE)

# 2.2. Transform numeric variable "METHOD" into factors
extraction_data$KIT_f <- factor(extraction_data$KIT, labels = c("NucleoSpin", "DNEasy"))

# 2.3. Create 2 subsets, one for each DNA extraction kit
NucleoSpin <- subset(extraction_data, extraction_data$KIT_f=="NucleoSpin")
DNEasy <- subset(extraction_data, extraction_data$KIT_f=="DNEasy")


##### PART. III : COMPUTE MAIN FUNCTION #####
desc_stat <- function(dataset=extraction_data,
                      var_to_assess,
                      var_name,
                      var_code,
                      multi_mode,
                      populations,
                      xlabel,
                      ylabel)
  
{
  # Checks the type of the variable
  print("(1) ASSESS THE TYPE OF THE VARIABLE", quote=FALSE)
  if(is.factor(var_to_assess))
  {
    print("Variable is qualitative", quote=FALSE)
    var_type <- 1
  }
  else 
  {
    print("Variable is quantitative", quote=FALSE)
    var_type <- 0
  }
  
  # If the variable is qualitative
  if (var_type==1) 
  {
    # Building the frequency table of the variable
    print("", quote=FALSE)
    print("(2) NUMERIC SUMMARY", quote=FALSE)
    Count <- table(var_to_assess)
    Percentage <- round(prop.table(Count)*100,2)
    CrossTable(var_to_assess)
    
    # Show the graphic summary n°1 (bar plot)
    print("", quote=FALSE)
    print("(3) GRAPHIC SUMMARY", quote=FALSE)
    print("The variable can be summarized graphically by a bar/pie chart", quote=FALSE)
    
    bar <- ggplot(dataset, aes(var_to_assess)) + 
      geom_bar(alpha=0.75, color = "black", fill= viridis(nlevels(var_to_assess))) + 
      labs(x=xlabel, y= "Frequency", title = ("Graphic summary of a qualitative variable"),
           subtitle = (paste("Barplot of frequency (count) by", tolower(xlabel))),
           caption = (paste("Data source : ", source))) + 
      theme(legend.position = "right", 
            legend.direction = "vertical",
            plot.title = element_text(color="#5c1c4c", 
                                      face="bold", 
                                      size=15, 
                                      hjust = 0),
            plot.subtitle = element_text(size=12, 
                                         hjust = 0),
            plot.caption = element_text(hjust=0))
    
    print(bar)
    
    # Show the graphic summary n°2 (pie chart)
    lab_val <- as.numeric(Percentage)
    lab_nam <- levels(var_to_assess)
    df <- as.data.frame(Percentage)
    colnames(df) <- c("class", "freq")
    labs <- paste(lab_nam,"|",lab_val,"%")
    
    pie <- ggplot(df, aes(x = "", y=freq, fill = factor(class))) +
      geom_bar(alpha=0.75, color = "black", width = 1, stat = "identity") +
      theme(axis.line = element_blank()) +
      scale_fill_manual("", values=viridis(nlevels(var_to_assess)), labels=labs)+ 
      coord_polar(theta = "y", start=0) + theme_minimal() + 
      labs(x=NULL, y=NULL) + 
      theme(legend.position = "top", legend.direction = "vertical") + labs(x=NULL, y=NULL, 
                                                                           title = ("Graphic summary of a qualitative variable"),
                                                                           subtitle = (paste("Pie chart of frequency (%) by the",var_name)),
                                                                           caption = (paste("Data source :", source))) + 
      theme(plot.title = element_text(color="#5c1c4c", 
                                      face="bold", 
                                      size=15, 
                                      hjust = 0.5),
            plot.subtitle = element_text(size=12, 
                                         hjust = 0.5), 
            plot.caption = element_text(hjust=2, vjust=3))
    print(pie)
  }
  
  # If the variable is quantitative
  else 
  {
    # Is the variable normally distributed ?
    print("", quote=FALSE)
    print("(2) ASSESS THE NORMALITY OF THE VARIABLE", quote=FALSE)
    # FIRST STEP : compare mean & median
    print("(2.1) MEAN & MEDIAN COMPARISON", quote=FALSE)
    mean <- round(mean(var_to_assess), 2)
    median <- round(median(var_to_assess), 2)
    sd <- round(sd(var_to_assess), 2)
    min <- min(var_to_assess)
    max <- max(var_to_assess)
    quantile <- quantile(var_to_assess)
    print(paste("Mean is equal to", mean, "and median is equal to", median), quote=FALSE)
    # SECOND STEP : assess skewness
    print("", quote=FALSE)
    print("(2.2) ASSESSMENT OF SKEWNESS", quote=FALSE)
    sk <- skewness(var_to_assess)
    if (between(sk, -0.5, 0.5))
    {
      print("Skewness indicates that the histogram is symmetric", quote=FALSE)
    }
    else if (sk < -0.5)
    {
      print("The distribution of the variable is left-skewed", quote=FALSE)
    }
    else if (sk > 0.5)
    {
      print("The distribution of the variable is right-skewed", quote=FALSE)
    }
    
    # THIRD STEP : build the histogram of the variable
    print("", quote=FALSE)
    print("(2.3) HISTOGRAM SYMMETRY", quote=FALSE)
    print("Please check the appearance of the curve in the plots tab", quote=FALSE)
    hist <- ggplot(dataset, aes(x=var_to_assess)) + 
      geom_histogram(bins=30, col = "black", aes(y = ..density.., fill = ..count..), alpha=0.75) +
      labs(x=ylabel, y= "Density") + 
      scale_fill_gradient("Count", low=viridis(1), high=viridis(30)) +
      stat_function(fun=dnorm,
                    color="red",
                    size=1.5,
                    args=list(mean=mean(var_to_assess), 
                              sd=sd(var_to_assess))) + 
      labs(title = (paste("Distribution of the", var_name)),
           subtitle = (paste("Histogram & estimated density")),
           caption = (paste("Data source : ", source))) + 
      theme(plot.title = element_text(color="#5c1c4c", 
                                      face="bold", 
                                      size=15, 
                                      hjust = 0),
            plot.subtitle = element_text(size=12, 
                                         hjust = 0))
    print(hist)
    
    # FOURTH STEP : build the QQ plot of the variable
    print("", quote=FALSE)
    print("(2.4) QQ-PLOT", quote=FALSE)
    print("Please check the appearance of the plot in the plots tab", quote=FALSE)
    data <- data.frame(var_to_assess)
    qq <- ggplot(data, aes(sample = var_to_assess)) + 
      stat_qq(color = "#815474") + stat_qq_line(col = "red", size=1.5) + 
      labs(x="Theoritical", y= "Sample") +
      labs(title = (paste("Distribution of the", var_name)),
           subtitle = ("Normal Q-Q plot"),
           caption = (paste("Data source : ", source))) + 
      theme(plot.title = element_text(color="#5c1c4c", 
                                      face="bold", 
                                      size=15, 
                                      hjust = 0),
            plot.subtitle = element_text(size=12, hjust = 0))
    print(qq)
    
    # FIFTH STEP : perform a Shapiro-Wilk normality test
    print("", quote=FALSE)
    print("(2.5) SHAPIRO-WILK NORMALITY TEST", quote=FALSE)
    shapiro_result <- shapiro.test(var_to_assess)
    p_val <- shapiro_result$p.value
    print(paste("The p-value of the test is equal to", p_val), quote=FALSE)
    if(p_val >= 0.05) 
    {
      print("According to Shapiro-Wilk normality test, distribution is normal (p >= 0.05)", quote=FALSE)
    } 
    else 
    {
      print("According to Shapiro-Wilk normality test, normality is rejected (p < 0.05)", quote=FALSE)
    }
    
    # SIXTH STEP : perform a Jarque-Bera normality test
    print("", quote=FALSE)
    print("(2.6) JARQUE-BERA NORMALITY TEST", quote=FALSE)
    jarque <- jarque.test(var_to_assess)$p.value
    print(paste("The p-value of the test is equal to", jarque), quote=FALSE)
    if(p_val >= 0.05) 
    {
      print("According to Jarque-Bera test, distribution is normal (p >= 0.05)", quote=FALSE)
    } 
    else 
    {
      print("According to Jarque-Bera test, normality is rejected (p < 0.05)", quote=FALSE)
    }
    
    
    # CONCLUSION : shows the numeric summary of the variable
    print("", quote=FALSE)
    print("(3) NUMERIC SUMMARY", quote=FALSE)
    print(paste("If the variable is normally distributed, it should be numerically summarized by applying mean(± standard deviation), which results in : ", mean, "(±", sd, ")"), quote = FALSE)
    print(paste("If the normality of the variable is rejected, it should be summarised numerically by applying median(Q25-Q75), which results in :", median, "(", quantile[2], "-", quantile[4], ")"), quote = FALSE)
    
    # CONCLUSION : shows the graphic summary of the variable
    print("", quote=FALSE)
    print("(4) GRAPHIC SUMMARY", quote=FALSE)
    print("The variable can be summarized graphically by a box-plot", quote=FALSE)
    # Create a function that builds a boxplot & its interpretation
    gg_boxplot <- function (var_to_assess, 
                            var_name="",
                            multi_mode="", 
                            populations="", 
                            xlabel="", 
                            ylabel="")
    {
      # Case where there's only 1 population
      if (multi_mode==FALSE) 
      {
        left_plot <- function (var_to_assess, var_name, ylabel)
        {
          layer1 <- ggplot(dataset, aes("", var_to_assess)) + 
            geom_boxplot(width=0.6,
                         alpha=0.75, 
                         color = "black",
                         fill=viridis(1)) +
            xlab(label = "") +
            ylab(label = ylabel) +
            stat_boxplot(geom ='errorbar', width = 0.15)
          
          layer2 <- layer1 + geom_point(color="black", alpha=0)
          
          layer3 <- layer2 + labs(title = ("Graphic summary of a quantitative variable"),
                                  subtitle = (paste("Box plot of the", var_name)),
                                  caption = (paste("Data source : ", source)))
          
          layer4 <- layer3 + theme(plot.title = element_text(color="#5c1c4c", 
                                                             face="bold", 
                                                             size=15, 
                                                             hjust = 0),
                                   plot.subtitle = element_text(size=12, 
                                                                hjust = 0), 
                                   plot.caption = element_text(hjust = 0))
          
          return(layer4)
        }
        LP <- left_plot(var_to_assess, var_name, ylabel)
      }
      
      # Case where there's more than 1 population
      else {
        left_plot <- function (var_to_assess, var_name, populations, xlabel, ylabel){
          layer1 <- ggplot(dataset, aes(populations, var_to_assess, fill=populations)) + 
            geom_boxplot(alpha=0.75) +
            xlab(label = xlabel) +
            ylab(label = ylabel) +
            stat_boxplot(geom ='errorbar', width = 0.15) +
            scale_fill_manual("", values=viridis(nlevels(populations)))
          
          layer2 <- layer1 + geom_point(color="black", alpha=0)
          
          layer3 <- layer2 + labs(title = ("Graphic summary of a quantitative variable"),
                                  subtitle = (paste("Box plot of the", 
                                                    var_name, "according to", tolower(xlabel))),
                                  caption = (paste("Data source : ", source)))
          
          layer4 <- layer3 + theme(plot.title = element_text(color="#5c1c4c", 
                                                             face="bold", 
                                                             size=15, 
                                                             hjust = 0),
                                   plot.subtitle = element_text(size=12, 
                                                                hjust = 0), 
                                   plot.caption = element_text(hjust = 0))
          
          layer5 <- layer4 + theme(legend.position = "bottom", 
                                   legend.title = element_text(colour="black",
                                                               face="bold", 
                                                               size=12))
          
          return(layer5)
        }
        LP <- left_plot(var_to_assess, var_name, populations, xlabel, ylabel)
      }
      
      # Build the legend of the boxplot
      right_plot <- function(family = "serif")
      {
        set.seed(100)
        sample_df <- data.frame(parameter = "test",
                                values = sample(500))
        sample_df$values[1:100] <- 701:800
        sample_df$values[1] <- -350
        
        ggplot2_boxplot <- function(x)
        {
          quartiles <- as.numeric(quantile(x,
                                           probs = c(0.25, 0.5, 0.75)))
          names(quartiles) <- c("1st quartile",
                                "Median",
                                "3rd quartile")
          IQR <- diff(quartiles[c(1,3)])
          upper_whisker <- max(x[x < (quartiles[3] + 1.5 * IQR)])
          lower_whisker <- min(x[x > (quartiles[1] - 1.5 * IQR)])
          upper_dots <- x[x > (quartiles[3] + 1.5*IQR)]
          lower_dots <- x[x < (quartiles[1] - 1.5*IQR)]
          
          return(list("quartiles" = quartiles,
                      "1st quartile" = as.numeric(quartiles[1]),
                      "Median" = as.numeric(quartiles[2]),
                      "3rd quartile" = as.numeric(quartiles[3]),
                      "IQR" = IQR,
                      "upper_whisker" = upper_whisker,
                      "lower_whisker" = lower_whisker,
                      "upper_dots" = upper_dots,
                      "lower_dots" = lower_dots))
        }
        
        ggplot_output <- ggplot2_boxplot(sample_df$values)
        update_geom_defaults("text",
                             list(size = 3,
                                  hjust = 0,
                                  family = family))
        update_geom_defaults("label",
                             list(size = 3,
                                  hjust = 0,
                                  family = family))
        explain_plot <- ggplot() +
          stat_boxplot(data = sample_df,
                       aes(x = parameter, y=values),
                       geom ='errorbar', width = 0.3) +
          geom_boxplot(data = sample_df,
                       aes(x = parameter, y=values),
                       width = 0.3, fill = "lightgrey") +
          geom_text(aes(x = 1, y = 950, label = ""), hjust = 0.5) +
          geom_text(aes(x = 1.22, y = 950,
                        label = ""),
                    fontface = "bold", vjust = 0.4) +
          theme_minimal(base_size = 5, base_family = family) +
          geom_segment(aes(x = 2.3, xend = 2.3,
                           y = ggplot_output[["1st quartile"]],
                           yend = ggplot_output[["3rd quartile"]])) +
          geom_segment(aes(x = 1.2, xend = 2.3,
                           y = ggplot_output[["1st quartile"]],
                           yend = ggplot_output[["1st quartile"]])) +
          geom_segment(aes(x = 1.2, xend = 2.3,
                           y = ggplot_output[["3rd quartile"]],
                           yend = ggplot_output[["3rd quartile"]])) +
          geom_text(aes(x = 2.4, y = ggplot_output[["Median"]]),
                    label = "Interquartile\nrange (IQR)", fontface = "bold",
                    vjust = 0.15) +
          geom_text(aes(x = c(1.22,1.22),
                        y = c(ggplot_output[["upper_whisker"]],
                              ggplot_output[["lower_whisker"]]),
                        label = c("Largest value within 1.5x\nIQR above 3rd quartile",
                                  "Smallest value within 1.5x\nIQR below 1st quartile")),
                    fontface = "bold", vjust = 0.9) +
          geom_text(aes(x = c(1.22),
                        y =  ggplot_output[["lower_dots"]],
                        label = "Outside value : "),
                    vjust = 0.5, fontface = "bold") +
          geom_text(aes(x = c(2.2),
                        y =  ggplot_output[["lower_dots"]],
                        label = "     is between 1.5x"),
                    vjust = 0.5) +
          geom_text(aes(x = 1.22,
                        y = ggplot_output[["lower_dots"]],
                        label = "and 3x the IQR beyond either\nend of the box"),
                    vjust = 1.5) +
          geom_label(aes(x = 1.22, y = ggplot_output[["quartiles"]],
                         label = names(ggplot_output[["quartiles"]])),
                     vjust = c(0.4,0.85,0.4),
                     fill = "white", label.size = 0) +
          ylab("") + xlab("") +
          theme(axis.text = element_blank(),
                axis.ticks = element_blank(),
                panel.grid = element_blank(),
                aspect.ratio = 4/3,
                plot.title = element_text(hjust = 0.5, size = 10)) +
          coord_cartesian(xlim = c(1.4,3.1), ylim = c(-600, 900)) +
          labs(title = "")
        return(explain_plot)
      }
      RP <- right_plot()
      
      # Merges the 2 graphs
      merged_plots <- plot_grid(LP, RP, nrow = 1, rel_widths = c(.6,.4))
      return(merged_plots)
    }
    
    gg_boxplot(var_to_assess, var_name, multi_mode, populations, xlabel, ylabel)
  }
  
}

##### PART. IV : RUN MAIN FUNCTION #####
# 4.1. Run in single mode to process data of the NucleoSpin kit
desc_stat(dataset=NucleoSpin,
          var_to_assess = NucleoSpin$CONCENTRATION, 
          var_name = "DNA concentration",
          var_code = "DNA extraction kit",
          multi_mode = FALSE,
          populations = "",
          xlabel = "",
          ylabel = "DNA concentration (ng/µL)")

# 4.2. Run in single mode to process data of the DNEasy kit
desc_stat(dataset=DNEasy,
          var_to_assess = DNEasy$CONCENTRATION, 
          var_name = "DNA concentration",
          var_code = "DNA extraction kit",
          multi_mode = FALSE,
          populations = "",
          xlabel = "",
          ylabel = "DNA concentration (ng/µL)")

# 4.3. Run in multi mode to process data of the whole dataframe
desc_stat(dataset=extraction_data,
          var_to_assess = extraction_data$CONCENTRATION, 
          var_name = "DNA concentration",
          var_code = "DNA extraction kit",
          multi_mode = TRUE,
          populations = extraction_data$KIT_f,
          xlabel = "Extraction kit",
          ylabel = "DNA concentration (ng/µL)")


##### PART. V : INFERENTIAL STATISTICS #####
# 5.1. Perform a Wilcoxon signed rank test for paired samples
wilcox.test(NucleoSpin$CONCENTRATION, DNEasy$CONCENTRATION, paired = TRUE)

# 5.2. Get descriptive statistics for power calculation
mean(NucleoSpin$CONCENTRATION)
mean(DNEasy$CONCENTRATION)
sd(NucleoSpin$CONCENTRATION)
sd(DNEasy$CONCENTRATION)
cor.test(NucleoSpin$CONCENTRATION, DNEasy$CONCENTRATION, method = "spearman")
