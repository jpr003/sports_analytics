#tutorial: http://www.r-bloggers.com/soccer-is-all-about-money-part-1-getting-the-data/

library(RCurl)
library(XML)
library(gdata)

buli.url <- "http://www.transfermarkt.de/1-bundesliga/startseite/wettbewerb/L1"
seriea.salaries <- "seriea_salaries.csv"
seriea.standings <- "seriea_standings.csv"

table.salaries = read.csv(seriea.salaries,header=TRUE,sep=",", quote = "\"")
table.standings = read.csv(seriea.standings,header=TRUE,sep=",", quote = "\"")
 
table.salaries <- data.frame(Team = table.salaries["Club"],
                    Squad = table.salaries["Squad"],
                    Age = table.salaries["Age"],
                    Value = table.salaries["Value"],
                    mValue = table.salaries["mValue"])

table.standings <- data.frame(Team = table.standings["Club"],
                             Squad = table.standings["Squad"],
                             Standing = table.standings["Position"],
                             GP = table.standings["GamesPlayed"],
                             W = table.standings["Win"],
                             L = table.standings["Lost"],
                             D = table.standings["Draw"],
                             GF = table.standings["GF"],
                             GA = table.standings["GA"],
                             GD = [[table.standings["GF"] - table.standings["GA"]],
                             PTS = table.standings["PTS"])

table.standings <- table.standings[order(table.standings$Squad),]
table.salaries <- table.salaries[order(table.salaries$Squad),]
names(table.standings)[names(table.standings) == "Squad"] <- "Team2"

big.tab <- cbind(table.standings, table.salaries)
all(big.tab$Squad == big.tab$Team2)

big.tab <- big.tab[order(big.tab$Position),-grep("Team2", names(big.tab), fixed=T)]

plot((big.tab$Value/big.tab$GF), big.tab$GF, type="n", axes=F,xlab="Euros per Goal", ylab="Goals")
text(x=(big.tab$Value/big.tab$GF), y=big.tab$GF, labels=paste(big.tab$Squad,"(#",big.tab$Position,")"), cex=.8, col="#65656599")
axis(side=1, at=axTicks(1), labels=formatC(axTicks(1), format="d", big.mark=','))
axis(side=2)
