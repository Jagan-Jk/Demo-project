
create or replace procedure Tbl_insert (P_group_name in varchar2,p_userId in number,p_ports in port_typ, p_msg out varchar2)as
lgrpid number;
gname varchar2(10);
Gcnt number;
user_ports varchar2(300);
excp_init exception;
begin

select count(group_name) into gcnt from port_group where lower(p_group_Name )=lower(group_Name);
if gcnt =0 then

select listagg(column_value,',') within group(order by column_value asc) into user_Ports from table(P_ports);
gcnt:=p_ports.count;
for j in (select listagg(port_id,',')within group(order by port_id asc) as tab_ports from port_child group by group_id having count(port_id)=gcnt)loop

if user_ports=j.tab_ports then
raise excp_init;
end if;
end loop;
insert into port_group values(port_sq.nextval,p_group_name,sysdate,p_userid) returning group_id,p_group_name into lgrpid,gname;
for i in 1..p_ports.count loop
insert into port_child values(group_sq.nextval,lgrpid,p_ports(i));
end loop;
p_msg:=('Group created '||gname);
commit;
elsif gcnt!=0 then
p_msg:='Same Group Name exists';
end if;
exception
when excp_init then
p_msg:='Same set of ports exits';
end;
/

commit;

alter sequence port_sq start with 2000 increment by 1 nomaxvalue;


declare
ab port_typ:=port_typ(1000,1002,1003,1004);
msg varchar2(200);
begin
tbl_insert(P_group_name=>'oracle',p_userid=>101,p_Ports=>ab,p_msg=>msg);
dbms_output.put_line(msg);
end;
/



select * from user_errors