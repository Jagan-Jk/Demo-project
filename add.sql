create or replace procedure test_1 as
a number:=10;
b number:=15;
p_out number;
p_out:=a*b;
dbms_output.put_line(P_out);
end;
/