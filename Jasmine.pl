%%FACTS
ownerAge(jasmine, 35).
mileage(jasmine, 50000).
accidentHistory(jasmine, 0).
violationHistory(jasmine, 1).
credit(jasmine, 730).

%%RULES

%%Define a safe driver
safeDriver(X) :- accidentHistory (X, A), A < 1, violationHistory (X, V), V =< 2.

%%Define a high-risk driver
highRiskDriver(X) :- accidentHistory (X, A), A >=3.
highRiskDriver(X) :- violationHistory (X, V), V >=3.

%%Define an average driver
averageDriver(X) :- accidentHistory (X, A), A >= 1, A < 3, violationHistory (X, V), V > 1, V < 3.

%%Evaluate mileage
lowMileage(X) :- mileage(X,M), M < 70000.
highMileage(X) :- mileage(X,M), M >= 70000.

%% Age of driver
youngDriver(X) :- ownerAge(X, A), A < 26.
seniorDriver(X) :- ownerAge(X, A), A > 65.
standardAgeDriver(X) :- ownerAge(X, A), A >= 26, A =< 65.

%% Credit
badCredit(X) :- credit(X, A), A =< 629.
averageCredit(X) :- credit(X, A), A > 629, A =< 719.
goodCredit(X) :- credit(X,A), A > 719.

%%Define cheap insurance 
%%A client can qualify for cheap insurance as long as they have the minimum of 1 or no negative aspects.
cheapInsurance(X) :- safeDriver(X), lowMileage(X), standardAgeDriver(X), goodCredit(X).
cheapInsurance(X) :- safeDriver(X), lowMileage(X), standardAgeDriver(X), averageCredit(X).
cheapInsurance(X) :- safeDriver(X), lowMileage(X), not standardAgeDriver(X), goodCredit(X).
cheapInsurance(X) :- safeDriver(X), highMileage(X), standardAgeDriver(X), goodCredit(X).
cheapInsurance(X) :- averageDriver(X), lowMileage(X), not standardAgeDriver(X), goodCredit(X).

%%Define standard insurance
%%A client can qualify for standard insurance as long as they have the 2 negative aspects.

standardInsurance(X) :- safeDriver(X), lowMileage(X), not standardAgeDriver(X), averageCredit(X).
standardInsurance(X) :- safeDriver(X), lowMileage(X), not standardAgeDriver(X), badCredit(X).
standardInsurance(X) :- safeDriver(X), lowMileage(X), standardAgeDriver(X), badCredit(X).
standardInsurance(X) :- safeDriver(X), highMileage(X), not standardAgeDriver(X), goodCredit(X).
standardInsurance(X) :- safeDriver(X), highMileage(X), standardAgeDriver(X), badCredit(X).
standardInsurance(X) :- averageDriver(X), lowMileage(X), standardAgeDriver(X), averageCredit(X).
standardInsurance(X) :- averageDriver(X), lowMileage(X), not standardAgeDriver(X), averageCredit(X).
standardInsurance(X) :- averageDriver(X), highMileage(X), standardAgeDriver(X), goodCredit(X).
standardInsurance(X) :- averageDriver(X), highMileage(X), not standardAgeDriver(X), goodCredit(X).
standardInsurance(X) :- highRiskDriver(X), lowMileage(X), standardAgeDriver(X), goodCredit(X).
standardInsurance(X) :- highRiskDriver(X), lowMileage(X), standardAgeDriver(X), averageCredit(X).


%%Define expensive insurance
%%If dui(X). is present then its automatically expensiveInsurance.
%%A client can qualify for expensive insurance as long as they have the 3 negative aspects or more.

expensiveInsurance(X) :- dui(X).
expensiveInsurance(X) :- highRiskDriver(X), highMileage(X), not standardAgeDriver(X),badCredit(X).
expensiveInsurance(X) :- highRiskDriver(X), highMileage(X),standardAgeDriver, badCredit(X).
expensiveInsurance(X) :- highRiskDriver(X), highMileage(X),not standardAgeDriver(X),goodCredit(X).
expensiveInsurance(X) :- safeDriver(X), highMileage(X), not standardAgeDriver(X),badCredit(X).
expensiveInsurance(X) :- safeDriver(X), highMileage(X),standardAgeDriver, badCredit(X).

%% Define a rule to determine the insurance type for Jasmine
insuranceType(X, expensive) :- expensiveInsurance(X).
insuranceType(X, standard) :- standardInsurance(X).
insuranceType(X, cheap) :- cheapInsurance(X).

%% Query the insurance type for Jasmine
?- insuranceType(jose, InsuranceType).
