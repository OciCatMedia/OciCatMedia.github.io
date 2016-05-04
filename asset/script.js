function FuzzifyDate(DateTarget) {
	var DateBeg = new Date(DateTarget);
	var DateEnd = new Date;
	var FuzzySuff = "ago";
	var FuzzyUnit = "";

	if (DateBeg > DateEnd) {
		DateEpoch = DateBeg - DateEnd;
		FuzzySuff = "from now";
	} else {
		DateEpoch = DateEnd - DateBeg;
	};

	FuzzyDate = Math.floor(DateEpoch / 1000);
	FuzzyUnit = "second";

	if (FuzzyDate >= 60) {
		FuzzyDate = Math.floor(FuzzyDate / 60);
		FuzzyUnit = "minute";
		if (FuzzyDate >= 60) {
			FuzzyDate = Math.floor(FuzzyDate / 60);
			FuzzyUnit = "hour";
			if (FuzzyDate >= 24) {
				FuzzyDate = Math.floor(FuzzyDate / 24);
				FuzzyUnit = "day";
				if (FuzzyDate >= 365) {
					FuzzyDate = Math.floor(FuzzyDate / 365);
					FuzzyUnit = "year";
				} else if (FuzzyDate >= 30) {
					if (DateBeg > DateEnd) {
						if (DateBeg.getUTCFullYear() == DateEnd.getUTCFullYear()) {
							FuzzyDate = DateBeg.getUTCMonth() - DateEnd.getUTCMonth();
						} else {
							FuzzyDate = 12 - (DateEnd.getUTCMonth() + 1) + (DateBeg.getUTCMonth() + 1);
						}
					} else {
						if (DateBeg.getUTCFullYear() == DateEnd.getUTCFullYear()) {
							FuzzyDate = DateEnd.getUTCMonth() - DateBeg.getUTCMonth();
						} else {
							FuzzyDate = 12 - (DateBeg.getUTCMonth() + 1) + (DateEnd.getUTCMonth() + 1);
						};
					};
					FuzzyUnit = "month";
				};
			};
		};
	};

	if (FuzzyDate != 1) {
		FuzzyUnit = FuzzyUnit + "s";
	};
	
	return(FuzzyDate + " " + FuzzyUnit + " " + FuzzySuff);
}

$( document ).ready(function() {
	$('[data-fuzzy]').html(function(){return FuzzifyDate($(this).data("fuzzy") * 1000)})
});
