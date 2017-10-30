function h = plot_rectangle(X, lineStyle)
%
% FUNCTION
%   PLOT_RECTANGLE takes rectangle bounds and plots the rectangle
%
% USAGE
%   H = PLOT_RECTANGLE(X, LINESTYLE).
%
% INPUT
%   X: The 4x1 matrix holding [x-start x-end y-start y-end]
%   LINESTYLE: A line style (whatever plot supports).
%
% OUTPUT
%   H: The handle to the created figure;
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   12/01/2012
%

    if nargin < 2
      % check the options
      lineStyle = 'r';
    end
    if nargin < 1
        error('PLOT_RECTANGLE: At least one argument is required.');
    end

    if ishold
        was_held = true;
    else
        was_held = false;
        hold on;
    end

    h = plot([X(1) X(2) X(2) X(1) X(1)], ...
             [X(3) X(3) X(4) X(4) X(3)], lineStyle);

    if ~was_held
        hold off;
    end

end
