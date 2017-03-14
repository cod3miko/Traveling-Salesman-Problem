function [] = tsp_nearestneighbor()

a = input('Enter the file name: ','s');
b = input('Enter starting city(concatenated and case-sensitive): ','s');
data = importdata(a);

%Splitting first line of cities into strings
cities = strsplit(char(data.textdata(1)),' ');
%Splitting second line of special case cities
cities2 = strsplit(char(data.textdata(2)),' ');
if strcmp('none',cities2)==0 %if string 'none' is not in line 2 assign special cities
    specialCity1 = char(cities2(1));
    specialCity2 = char(cities2(2));
    fprintf('Must visit %s before %s \n', specialCity1, specialCity2)
elseif strcmp('none',cities2)==1 %if string 'none' exists then sp's are -1 and obsolete
    specialCity1 = -1;
    specialCity2 = -1;
end
%Getting adjacency matrix info
dist = data.data;

%loop to check if user inputted city exists via stringmatching
%if so assign it as a starting city
%also for special cities
for i = 1:numel(cities)
    if strcmp(b,cities(i))==1
        startCity = i;
    end
    %special case cities
    if strcmp(specialCity1,cities(i))==1
        specialCity1 = i;
    end
    if strcmp(specialCity2,cities(i))==1
        specialCity2 = i;
        if (specialCity2 == startCity)
            %case where the second special city is what user wanted to start out with
            error('Not A Possible itinerary');
        end
    end
end
%starting the nearest neighbor algo
for i = 1:numel(cities)
    distTrav = 0; %initialize total distance traveled
    distNew = dist; %distNew will be the affected adj matrix(b/c original adj matrix will still be used)
    path = startCity; %path will start with startingCity number and build from there as an array
    currCity = path; %assigning a current city 
    weights = []; %to store minimum dist after each iteration
    
    %if statement to help specify whether special city condition was met
    %and the case where special cities do not exist
    if specialCity1 == -1
        target = 2;
    else
        target = 0; 
    end
    
    %finding the nearest neighbors
    for j = 1:numel(cities)-1 %training on n-1
        %checking if special condition was met
        if (target == 1) %unlock distances for special city 2
            distNew(specialCity2,:) = dist(specialCity2,:); %obtaining row values
            target = 2;
        elseif (target == 0) %lock distances for special city 2
            distNew(specialCity2,:) = Inf;
        end
        
        %find min from all cities of the current city's row using
        %adj matrix and then store it in an array as the [smalles dist,thatCity'sIndex(aka nextCity)]
        %this is the power house of the algorithm
        [minDist,nextCity] = min(distNew(:,currCity)); 
        
        %special condition modifier
        if (nextCity == specialCity1)
            target = 1;
        elseif (path == specialCity1)
            target = 2;
        end
        
        path(end+1) = nextCity; %adds each city# to the path at the last index after each iteration
        distTrav = distTrav + dist(currCity,nextCity); %cumulating distances traveled from original adj matrix
        weights(j) = dist(currCity,nextCity);%storing the min dist
        distNew(currCity,:) = Inf; %delete row of the current city so that the same city never goes thru twice
        currCity = nextCity; %assign curr to next for iteration
    end
    path(end+1) = startCity; %finalizing path by going back to the start
    distTrav = distTrav + dist(currCity,startCity); %final distance trav by adding dist back to start
    weights(end+1) = dist(currCity,startCity); %final set of min dist's incl back to starting point
end %end nested loop
%printing methods
if (distTrav == Inf) %condition where a circuit does not exist
    disp('No Possible Itinerary');
else %print output
    %This is for printing the string(cell) of city names from path order index
    for i = 1:numel(path)
        output(i) = cities(path(i));
    end
    %printing out results
    for i = 1:numel(weights)
        fprintf(char(output(i))) %turning strings into char for output formatting
        fprintf(' %d ',weights(i)) %printing out weights
    end
    fprintf(char(output(end))) %printing the ending city(last index) b/c the printing loop would not index it
    fprintf('\nTotal Distance Traveled: %d \n',distTrav) %printing the total dist traveled
end
end