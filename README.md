# symmetrical-funicular


A github client to search repositories by username. 

# Architecture

### MVVM

This is an opinionated version of MVVM implemented with SwiftUI

## Layers

### Model:
 Contains our data model which holds information about data fetched from the github API

### UI:
 Contains views and view models

### Service:
 Bridge class to help view models interface with API and Network dependencies. Other dependencies could be added as needed

### API:
 Defines how to call APIs with the network layer as a dependency. Other dependencies could be added like security interfaces as needed 

### NetworkL
 Defines a network client which is used to make API requests. Protocol based and can be swapped out with other networking implementations



# Features

I was tasked with the following requirements:

1. Repository search screen should have a search bar on the top, repositories should be searched by it’s owner account username
2. Each repository should display username, avatar, and repository name.
3. The list should be paginated, use ‘page’ and ‘per_page’ API endpoint query params.
4. Implement error and loading states

All complete ✅

### Additional Features :

1. Dark mode support

## Design Inspiration:
https://dribbble.com/shots/14912562-Github-Social-App
![plot](./design.png)