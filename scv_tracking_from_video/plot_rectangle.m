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


%    Copyright (C) 2012  Christos Bergeles <christosbergeles@gmail.com>
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
