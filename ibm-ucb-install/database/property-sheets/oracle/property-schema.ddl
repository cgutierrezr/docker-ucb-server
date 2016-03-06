-- Licensed Materials - Property of IBM Corp.
-- IBM UrbanCode Build
-- IBM UrbanCode Deploy
-- IBM UrbanCode Release
-- IBM AnthillPro
-- (c) Copyright IBM Corporation 2002, 2014. All Rights Reserved.
--
-- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
-- GSA ADP Schedule Contract with IBM Corp.

create table ps_prop_sheet_group (
    id varchar2(36) not null primary key,
    version numeric default 0 not null
);


create table ps_prop_sheet_def (
    id varchar2(36) not null primary key,
    version numeric default 0 not null,
    name varchar2(255),
    description varchar2(4000),
    prop_sheet_group_id varchar2(36),
    template_handle varchar2(255),
    template_prop_sheet_def_id varchar2(36)
);


create table ps_prop_def (
    id varchar2(36) not null primary key,
    version numeric default 0 not null,
    prop_sheet_def_id varchar2(36) not null,
    name varchar2(255) not null,
    description varchar2(4000),
    label varchar2(255),
    default_value varchar2(4000),
    long_default_value clob,
    property_type varchar2(64),
    required varchar2(1) not null,
    hidden varchar2(1) not null,
    index_order numeric,
    allowed_prop_sheet_def_id varchar2(36),
    pattern varchar2(255)
) lob (long_default_value) store as ps_prop_default_value_lob;


create table ps_prop_def_allowed_value (
    id varchar2(36) not null primary key,
    version numeric default 0 not null,
    prop_def_id varchar2(36) not null,
    value varchar2(4000) not null,
    label varchar2(255),
    index_order numeric
);


create table ps_prop_sheet_handle (
    id varchar2(36) not null primary key,
    version numeric default 0 not null,
    prop_sheet_handle varchar2(255) not null,
    prop_sheet_def_id varchar2(36) not null
);


create table ps_prop_sheet (
    id varchar2(36) not null primary key,
    version numeric default 0 not null,
    name varchar2(255),
    prop_sheet_group_id varchar2(36),
    prop_sheet_def_id varchar2(36),
    prop_sheet_def_handle varchar2(255),
    template_prop_sheet_id varchar2(36),
    template_handle varchar2(255)
);


create table ps_prop_value (
    id varchar2(36) not null primary key,
    version numeric default 0 not null,
    name varchar2(255) not null,
    value varchar2(4000),
    long_value clob,
    description varchar2(4000),
    secure varchar2(1),
    prop_sheet_id varchar2(36) not null
) lob (long_value) store as ps_prop_value_lob;


create table ps_db_version (
    release_name  varchar2(255) not null,
    ver           numeric default 0 not null
);
