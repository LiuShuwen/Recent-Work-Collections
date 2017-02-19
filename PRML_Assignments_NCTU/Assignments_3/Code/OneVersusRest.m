function [y] = OneVersusRest(trainLabel, tag)
	y(trainLabel==tag)=1;
	y(trainLabel~=tag)=-1;
