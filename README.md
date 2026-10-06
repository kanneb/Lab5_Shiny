# Lab5_Shiny

An interactive application that shows where earthquakes taken place andthe magnitude of each eartquake. Shows a map where continent can be choosen and the distrubution of the magnitude of selected continent.

``` r
# Requierd packages
library(shiny)
library(leaflet)
library(ggplot2)

# Lab5PKG can be downloaded from github using these commands:
remotes::install_github("https://github.com/kanneb/Lab5PKG.git")
library(Lab5PKG)
```

To run the app the following command is needed.

``` r
runGitHub("Lab5_Shiny", "kanneb", subdir = "Earthquake_App")
```

