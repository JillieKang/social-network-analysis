# Social Network Analysis

## Overview
This repository contains practice materials and programming exercises from the 2025 Social Data Programming course at Kyung Hee University. Most of web crawling scripts are based on teaching materials developed by Professor Sujin Choi and are included here with her permission for non-commercial and academic purposes.

R scripts and HTML files are available in the `practices` folder and via the links below. For HTML files, it is recommended to view the rendered versions through the links below rather than opening the raw files directly.

## Practices: Rendered HTML Files 
[1. Web Scraping and Data Collection Using RSelenium (.R)](https://JillieKang.github.io/social-network-analysis/practices/001_web_scraping.R)

[2. Edge Lists and Networks (.html)](https://JillieKang.github.io/social-network-analysis/practices/002_edge_list.html)

[3. Network Centrality, Density, and Centralization Analysis of and Visualization (.html)](https://JillieKang.github.io/social-network-analysis/practices/003_centrality_density_centralization.html)

## Skills Developed
- Web crawling and data collection
- Browser automation using RSelenium
- Social network analysis (SNA)
- Network construction from interaction data
- Edge list generation
- Adjacency matrix construction
- Directed and weighted network analysis
- Centrality analysis
- Network density and centralization analysis
- Community detection
- Network visualization

## Tools
- R
- R Markdown
- knitr
- HTML
- GitHub Pages

## R Packages
- RSelenium
- rvest
- igraph
- dplyr
- tidyr
- curl

## Practices: Topics Covered

### 1. Web Crawling and Data Collection Using RSelenium

#### Functions
- `remoteDriver()`
- `open()`
- `navigate()`
- `getPageSource()`
- `URLencode()`
- `read_html()`

#### Key Operations
- Constructing dynamic URLs with search keywords and page numbers
- Encoding Korean search terms for web requests
- Automating browser interactions using RSelenium
- Extracting HTML source code from web pages
- Collecting post lists across multiple pages
- Gathering detailed information for individual posts
- Collecting hierarchical comment data
- Removing duplicated posts
- Filtering collected data by date range

### 2. Constructing Edge Lists and Networks

#### Functions
- `strsplit()`
- `unnest()`
- `graph_from_data_frame()`
- `as_adjacency_matrix()`
- `as_data_frame()`
- `vcount()`

#### Key Operations
- Assigning unique IDs to users
- Constructing directed edge lists from posts, comments, replies, and re-replies
- Identifying sender–target relationships across multiple interaction levels
- Transforming hierarchical comment structures into network ties
- Removing duplicated relations and self-loops
- Constructing directed binary networks
- Constructing directed weighted networks
- Creating weighted edge attributes based on interaction frequencies
- Converting edge lists into adjacency matrices
- Integrating node-level attributes
- Generating dyadic similarity matrices based on shared political orientations

### 3. Network Centrality, Density, and Centralization Analysis and Visualization

#### Functions
- `graph_from_adjacency_matrix()`
- `plot()`
- `degree()`
- `strength()`
- `induced_subgraph()`
- `betweenness()`
- `edge_density()`
- `centr_degree()`
- `cluster_edge_betweenness()`
- `membership()`
- `vcount()`
- `is_directed()`

#### Key Operations
- Converting adjacency matrices into directed weighted networks
- Visualizing network structures using force-directed layouts
- Calculating indegree, outdegree, and total degree centrality
- Calculating weighted degree centrality using edge weights
- Identifying highly central nodes in the network
- Examining degree distributions through histograms and descriptive statistics
- Scaling node sizes according to centrality values
- Creating subnetworks based on degree centrality thresholds
- Calculating betweenness centrality
- Measuring network density in binary and weighted forms
- Measuring network centralization
- Detecting communities using the Newman–Girvan algorithm
- Extracting community memberships and cluster structures
- Visualizing community structures within the network



