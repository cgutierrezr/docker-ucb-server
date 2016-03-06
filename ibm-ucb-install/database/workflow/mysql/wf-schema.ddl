-- Licensed Materials - Property of IBM Corp.
-- IBM UrbanCode Build
-- IBM UrbanCode Deploy
-- IBM UrbanCode Release
-- IBM AnthillPro
-- (c) Copyright IBM Corporation 2002, 2014. All Rights Reserved.
--
-- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
-- GSA ADP Schedule Contract with IBM Corp.
create table wf_db_version (
    release_name varchar(256) binary not null,
    ver integer default 0 not null
) engine = innodb;

create table wf_workflow (
    id varchar(36) binary not null primary key,  
    workflow_data longblob not null
) engine = innodb;

create table wf_dispatched_task (
    id varchar(36) binary not null primary key,
    workflow_id varchar(36) binary not null,
    context_id varchar(36) binary not null,
    dispatched varchar(1) binary not null,
    method_name varchar(128) binary not null,
    priority integer not null,
    method_data longblob
) engine = innodb; 

create table wf_workflow_trace (
    id varchar(36) binary not null primary key,
    workflow_trace_data longtext not null
) engine = innodb;


create index wf_disp_task_wfid on wf_dispatched_task(workflow_id);
