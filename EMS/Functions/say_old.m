function say_old(myString)
% [] = say_old('string')
% uses excel voice to say the string 

xl = actxserver('excel.application');
xl.Workbooks.Add(1);
cell = xl.ActiveSheet.Range('A1');
set(cell,'Value',myString);
cell.Speak;     % Amazing!
set(xl.ActiveWorkbook,'Saved',2)
xl.Quit;