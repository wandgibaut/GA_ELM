function parents = rankSelection(expectation, nParents, options)
%options = optimset(@ga, 'Vectorized','on');

	denominator = sum(expectation);

	ranks = expectation./denominator;

	Pop_ranks = ranks*length(expectation);

	index_parents = [];

	for i=1:nParents
		r = rand();
		for j = 1:length(ranks)
			if j ==1 && r <= ranks(j)
				index_parents(length(index_parents)+1) = j;
        break
			elseif r <= sum(ranks(1:j))
				index_parents(length(index_parents) +1) = j;
        break
			end
		end

	end
    parents =index_parents;
end