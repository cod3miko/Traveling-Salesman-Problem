function [P] = trotter(numCities,startCity)
%This functions gonna generate all unique permutations of (n-1)!
%   it will output an array of all permutations in P

%the following codes are purposed for preparing permutations via taking out
%the starting city and generating all permutations on the rest of the
%cities, by which afterwards..the starting city will be placed in the
%beginning and end of each permutation
p = 1:numCities; %created array containing integers from 1 to n
for i = 1:numCities %this loop obtains the index of the startCity in p
    if startCity == p(i)
        idx = p(i);
    end %purpose of this index is to create an array without the starting city
end
tmpStartCity = p(idx); %index of startCity is stored in a temp variable for further use
p = p(p~=idx); %removes startingCity from array of [1...n]
n = length(p); %basically n=n-1
P = zeros(0,numCities+1);%initializing for the output of permutations (including ending city)
%d = []; %an array for the directions of the integers
for i = 1:n %this loop makes all starting directions point left
    d(i) = -1;
    %left is -1,right is 1
end

numOfPerms = factorial(n); %n here is already n-1
%finding the largest mobile integer for next perm
for i = 1:numOfPerms
    
    P(i,1)=tmpStartCity; %puts startCity in the beginning of all OUTPUTS
    P(i,2:end-1)=p; %all outputs of trotter's algo
    P(i,end)=tmpStartCity; %puts startCity in the end of all outputs
    
    %this for loop determines the largest mobile integer and its index
    largestMobile = 0;
    for j = 1:n 
        %If an integer is not on the leftmost column pointing to the left
        %and not on the rightmost column pointing to the right then it
        %is a mobile integer
        if (~(j==1  && d(j)== -1) && ~(j==n && d(j)==1))
            %if an integer is larger than the adjacent one in its direction
            %and larger the current largest mobile integer then it is the
            %largest mobile integer
            if (p(j) > p(j+d(j)) && (p(j) > largestMobile))
                largestMobile = p(j);
                largestMobileIndex = j;
            end
        end
    end
    %swapping the largest mobile integer with the adjacent one in its direction
    temp = p(largestMobileIndex);
    p(largestMobileIndex) = p(largestMobileIndex + d(largestMobileIndex));
    p(largestMobileIndex + d(largestMobileIndex)) = temp;
    %performing the same thing on the direction array to keep it
    %synchronized
    temp = d(largestMobileIndex + d(largestMobileIndex));
    d(largestMobileIndex + d(largestMobileIndex)) = d(largestMobileIndex);
    d(largestMobileIndex) = temp;
    %swapping the direction of all integers larger than the current largest mobile
    for j = 1:n
        if p(j) > largestMobile
            if d(j) == -1
                d(j) = 1;
            else
                d(j) = -1;
            end
        end
    end
end
end
