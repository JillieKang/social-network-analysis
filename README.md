# Social Network Analysis

## Overview
This repository contains practice materials and programming exercises from the 2025 Social Data Programming course at Kyung Hee University. Most of web crawling scripts are based on teaching materials developed by Professor Sujin Choi and are included with permission for non-commercial and academic purposes.

R scripts and HTML files are available in the `practices` folder and via the links below. For HTML files, it is recommended to view the rendered versions through the links below rather than opening the raw files directly.

## Practices: Rendered HTML Files 
[1. Web Crawling and Data Collection Using RSelenium (.R)](https://JillieKang.github.io/social-network-analysis/practices/001_web_crawling.R)

[2. Edge Lists and Networks (.html)](https://JillieKang.github.io/social-network-analysis/practices/002_edge_list.html)

[3. Network Centrality, Density, and Centralization Analysis of and Visualization (.html)](https://JillieKang.github.io/social-network-analysis/practices/003_centrality_density_centralization.html)

## Practices: Topics Covered

### 1. Web Crawling and Data Collection Using RSelenium

#### Functions
- `remoteDriver()`
- `open()`
- `navigate()`
- `getPageSource()`
- `URLencode()`
- `read_html()`
- `scrap_vec_of_post_for_()`
- `get_post_detail_info()`
- `get_all_of_comment_df()`
- `write.xlsx()`

#### Data Sets
- Ppomppu Freeboard search results
- Post metadata
- Post details
- Comment data

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
- Exporting crawled data to Excel files

### 2. Constructing Edge Lists and Networks

#### Functions
- `left_join()`
- `inner_join()`
- `group_by()`
- `summarise()`
- `mutate()`
- `replace_na()`
- `strsplit()`
- `unnest()`
- `graph_from_data_frame()`
- `as_adjacency_matrix()`
- `as_data_frame()`
- `vcount()`
- `write.xlsx()`
- `write.csv()`

#### Data Sets
- Post metadata
- Comment data
- User ID mappings
- Edge lists
- Adjacency matrices
- Political orientation data

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
- Sorting node IDs for QAP analysis
- Integrating node-level political orientation attributes
- Generating dyadic similarity matrices based on shared political orientations
- Exporting network data for subsequent social network analysis

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
- `write.xlsx()`

#### Data Sets
- Weighted adjacency matrices
- Directed weighted networks
- Degree centrality measures
- Betweenness centrality measures
- Community membership data

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



