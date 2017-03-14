function [] = tsp_bruteforce()
a = input('Enter the file name: ','s');
b = input('Enter starting city(concatenated and case-sensitive): ','s');

tic;%start time
data = importdata(a); %importing data
%Splitting first line of cities into strings
cities = strsplit(char(data.textdata(1)),' ');
%Splitting second line of special case cities
cities2 = strsplit(char(data.textdata(2)),' ');
if strcmp('none',cities2)==0 %if string 'none' is not in line 2,then assign special cities
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
    end
end
if (specialCity2 == startCity)
    %case where the second special city is what user wanted to start out with
    error('Not A Possible itinerary');
end

numCities = length(cities);%number of total cities
[P] = trotter(numCities,startCity); %SJT algorithm that generates perms only where startCity is first

%the special condition cities
%if there exists special cities, the following triple nested for loop finds
%the index of each special city for each permutation and splits the output
%into two arrays - one containing passable routes and the other,unpassable routes
if specialCity1 ~= -1
    for i = 1:length(P)
        dummy = P(i,:);
        for x = 1:numCities
            if dummy(:,x) == specialCity1
                for y = 1:numCities
                    if dummy(:,y) == specialCity2
                        if x > y %if index of sp1 is > sp2(ie sp1 came after sp2 in permutation)
                            Ptrash(i,:) = P(i,:); %obsolete - put permutation in a trash array
                        else
                            Pgood(i,:) = P(i,:); %the passable permutations go here
                            Pgood(all(~Pgood,2),:) = []; %removes zeros
                        end
                    end
                end
            end
        end
    end
    P=Pgood; %final output P
end

weights = []; %city to city distance
distTrav = []; %overall distance
for i = 1:length(P)
    temp = P(i,:); %temp variable to store one iteration of a permutated path
    for j = 1:numCities
        weights(:,j) = dist(temp(j),temp(j+1));%getting weights of the perm
    end
    distTrav(i,:) = sum(weights);%calculating each perm's overall dist 
    weights=0; %start over so as not to build a crazy huge array 
end
[output,index] = min(distTrav); %this determines the minimum dist and it's index
%now i use the index to find that specific path from distPath
for i = index
    path = P(i,:); %getting the final path
    for j = 1:numCities
        [weights(:,j)] = dist(path(j),path(j+1)); %getting the final weights
    end
end

%Printing timeeeee
if (output == Inf) %condition where a circuit/edge does not exist
    error('No Possible Itinerary');
else %print output
    %This is for printing the string(cell) of city names from path order index
    for i = 1:numel(path)
        final(i) = cities(path(i));
    end
    %printing out results
    for i = 1:numel(weights)
        fprintf(char(final(i))) %turning strings into char for output formatting
        fprintf(' %d ',weights(i)) %printing out weights
    end
    fprintf(char(final(end))) %printing the ending city(last index) b/c the printing loop would not index it
    fprintf('\nTotal Distance Traveled: %d \n',output) %printing the total dist traveled
end
toc;%end time
end
