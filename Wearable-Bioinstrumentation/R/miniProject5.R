install.packages("tidyverse")
# clear workspace
rm(list = ls())# load packages
library(tidyverse)
library(magrittr)

# load data
data <- read.csv('C:/Users/kamil/git/Wearable-Bioinstrumentation/Data/rrData.csv') # data should be 140 obss x 4 variables
data$participant <- factor(data$participant) # make participant variable a factor
table(data$participant) # should be 10 repeats per participant


# LINE PLOT ----
# reshape the data into long format so that there are 4 columns: participant, time, feature (rr or rr_fft), and value
data_long <- data %>% gather(key = "Feature_Kawka", value = "value", -participant, -time)

 # data_long should be 280 obs. x 4 variables

# line plot
ggplot(data_long, aes(x = time, y = value, color = Feature_Kawka)) +
  geom_point() +
  geom_line() +
  ggtitle("Figure 1: Line Plot") +
  xlab("Elapsed Time(s)") +
  ylab("RR(brpm)") +
  theme(legend.position = "top") +
  theme(panel.background = element_blank()) +
  facet_wrap(data$participant, ncol = 7)

# BAR PLOT ----,
# find the mean and standard deviation within each participant-feature
summary <- data_long %>% group_by(participant, Feature_Kawka) %>% summarize(mean = mean(value), sd = sd(value)) # summary should be  28 obs. x 4 variables

# bar plot
ggplot(summary, aes(x = participant, y = mean, fill = Feature_Kawka)) +
  geom_bar(aes(fill = Feature_Kawka),stat = "identity",position = "dodge") +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd),width=0.3, position=position_dodge(.9)) +
  ggtitle("Figure 2: Bar Plot") +
  theme(legend.position = "top") +
  theme(panel.background = element_blank()) +
  xlab("Participant") +
  ylab("RR(brpm)")
  
  
  # SCATTER PLOT ----
# fit linear model to data, y = rr_fft, x = rr)
fit <- lm(data$rr_fft ~ data$rr)

# combine text for equation
eq <- substitute(italic(y) == a + b %.% italic(x)*", "~~italic(r)^2~"="~r2, 
                 list(a = format(unname(coef(fit)[1]), digits = 2),
                      b = format(unname(coef(fit)[2]), digits = 2),
                      r2 = format(summary(fit)$r.squared, digits = 2)))
text <- as.character(as.expression(eq));

# scatter plot
ggplot(data, aes(x = rr, y = rr_fft)) +
  geom_point() +
  geom_smooth(method = "lm") +
  ggtitle("Figure 3: Scatter Plot") +
  annotate("text", x = 30, y = 30, label = text, parse = TRUE) +
  theme(legend.position = "top") +
  theme(panel.background = element_blank()) +
  xlab("RR(brpm)") +
  ylab("RR FFT(brpm)")


# BLAND-ALTMAN PLOT ----
# caclulate and save the differences between the two measures and the averages of the two measures
data %<>% mutate(average = (rr+rr_fft)/2, difference = rr-rr_fft)
print(mean(data[,6]))
print(mean(data[,6] + 1.96*sd(data[,6])))
print(mean(data[,6] - 1.96*sd(data[,6])))

# Bland-Altman plot
ggplot(data, aes(x=average, y=difference)) +
  geom_point(alpha = 0.3)+
  ylim(-10,20) +
  geom_hline(aes(yintercept=mean(difference)), col="green", size=1)+
  geom_hline(aes(yintercept=mean(difference)+ 1.96*sd(difference)), linetype='dashed', col="orange", size=1)+
  geom_hline(aes(yintercept=mean(difference)- 1.96*sd(difference)), linetype='dashed', col="orange", size=1)+
  annotate("text", x=25, y=20, label = "Mean: 2.98", parse = TRUE) +
  annotate("text", x=25, y=18, label = "LoA: (-5.82 - 11.78)", parse = TRUE) +
  ggtitle("Figure 4: Bland-Altman Plot") +
  xlab("Average of Measures(brpm)") +
  ylab("Difference Between Measures(rr-rr_fft)(brpm)") +
  theme(panel.background = element_blank())


# BOX PLOT ----
# box plot
ggplot(data, aes(x = participant, y = difference, color = participant)) +
  geom_boxplot(outlier.shape=16, outlier.size=2, notch=FALSE)+
  ggtitle("Figure 5: Box Plot") +
  xlab("Participant") +
  ylab("Difference Between Measure(rr-rr_fft)(brpm)(Kawka)") +
  theme(panel.background = element_blank())