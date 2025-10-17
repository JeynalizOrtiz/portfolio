Portfolio
First assignment EVR628

Name: Jeynaliz Ortiz Gonzalez 

I am a second year Masters of Professional Science student in the Marine 
Conservation track. I am also an intern at the Shark Research and Conservation 
Lab, where I study shore-based subsistence fisheries in Miami-Dade County. 
Outside of academia, I'm a sea turtle biologist and the current lead for the 
artificial lighting team. My job requires handling disorientation data and 
reporting it to FWC. 

This Read Me file has been created as a requirement for the first assignment for
EVR628. 

The plot created in this project uses the Hurrican Milton data available in the
EVR628 package. I have created a scatter plot using measurements for latitude 
longitude (location of hurricane milton) and compared that to the speed at these 
varying locations. 

Update - October 16, 2025

This project contains data relevant to sea turtle hatchling disorientations at
the moment of emergence for the 2025 year. Data showcases all disorientations in
beaches located within 5 sites: Key Biscayne, Fisher Island, Miami Beach, 
Haulover, and Golden Beach. 

Objective: To display a heatmap that identifies disorientation hotspots and 
later combine with property GPS coordinates to determine which coastal properties
are located within disorientation hotspots.

Repository: gitignore, data folder, README, results folder,and scripts folder 

Column names: date, nest, species, latitude, longitude, direction, disorientated.

Description:

date : Categorical. Format - mm/dd/yyyy 
      Signifies the date in which hatch and disorientation occurred.

nest : Numerical discrete. Format -

MB-N-### - Miami Beach nest and assigned number
FI-N-### - Fusher Island nest and assigned number
HO-N-### - Haulover nest and assigned number
KB-N-### - Key Biscayne nest and assigned number
GB-N-### - Golden Beach nest and assigned number

MN - Prefix for missed nest (previosuly unmarked) found by hatch. Labeled by 
     month, day, beach, surveyor initials and number of missed nest per surveyor by day.
     Ex.: MNGB1012JOG1 - Missed nest found on Golden Beach on October 12 by
                         JOG; 1st nest found by surveyor of the day.
    
C###RBH - Label assigned to relocated nests from the 2025 Bal Harbour 
          renourishment project area. "C" stands for C. caretta, followed by 
          nest number,followed by "R" for relocation and "BH" for Bal Harbor. 

NA - No hatch disorientation
          
species : Categorical. Format - G. species

C. caretta - Caretta caretta
C. mydas - Chelonia mydas
D. coriacea - Dermochelys coriacea

latitude : Numerical continuous. Written with 5 decimal places.

longitude : Numerical continuous. Written with 5 decimal places.

direction : Categorical. Cardinal direction in which the sea turtles disoriented upon
            emergence.
            
disoriented : Numerical discrete. Number of sea turtles disoriented based on

<10 : less than 10
11-50 
#>50 : over 50
