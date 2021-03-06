##################################################################
##
## makeGenderTable.R
## Author: SFW
##
## This takes the master roster from the XLABs project and makes a table of genders and majors
##
##################################################################

library(tables)

master.dat = read.csv('./data/masterRoster.csv')

p1251f19 = master.dat[master.dat$Course=='PHYS1251' & master.dat$Semester=='F19', ]
p1261s20 = master.dat[master.dat$Course=='PHYS1261' & master.dat$Semester=='S20', ]
physDat = master.dat[master.dat$Course=='PHYS1251' | master.dat$Course=='PHYS1261', ]
physDat$Course = factor(physDat$Course)


tabular( (Gender + 1) ~ ((n=1) + Percent("col"))*Course, data=physDat)

gender.tab = tabular( (Gender + 1) ~ (Percent("col"))*Course, data=physDat)

write.csv.tabular(gender.tab, file='./data/physLabGender.csv')


## This makes tables of all of our majors in PHYS 1251/1261
data = c('p1251f19','p1261s20')
for(d in data){
    dat = eval(as.symbol(d))
    major.mat = as.matrix(tabular( (MAJOR + 1) ~ Percent("col"), data=dat))
    major.df = as.data.frame(major.mat[-1, ])
    names(major.df) = major.mat[1, ]

    ## Sort ascending
    major.df = major.df[order(major.df$Percent), ]
    ## Now flip the order
    major.df = major.df[nrow(major.df):1, ]

    ## Write this to a spreadsheet
    fName = paste0(d,'major.csv')
    write.csv(major.df, file=fName)
}

