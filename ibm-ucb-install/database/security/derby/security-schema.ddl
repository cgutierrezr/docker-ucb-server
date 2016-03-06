-- Licensed Materials - Property of IBM Corp.
-- IBM UrbanCode Build
-- IBM UrbanCode Deploy
-- IBM UrbanCode Release
-- IBM AnthillPro
-- (c) Copyright IBM Corporation 2002, 2014. All Rights Reserved.
--
-- U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
-- GSA ADP Schedule Contract with IBM Corp.
-- ============================================================================
--  versioning table
-- ============================================================================

create table sec_db_version (
    release_name varchar(36) not null,
    ver integer default 0 not null
);

insert into sec_db_version (release_name, ver) values ('1.0', 21);

-- ============================================================================
--  security tables
-- ============================================================================

create table sec_action (
    id varchar(36) not null,
    version integer default 0 not null,
    name varchar(64) not null,
    description varchar(1024),
    enabled varchar(1) default 'Y' not null,
    cascading varchar(1) default 'N' not null,
    sec_resource_type_id varchar(36) not null,
    category varchar(64),
    primary key (id)
);

create table sec_auth_token (
    id varchar(36) not null,
    version integer default 0 not null,
    sec_user_id varchar(36) not null,
    token varchar(255) not null,
    expiration bigint not null,
    description varchar(1024),
    os_user varchar(255),
    host varchar(255),
    primary key (id)
);

create table sec_authentication_realm (
    id varchar(36) not null,
    version integer default 0 not null,
    name varchar(64) not null,
    description varchar(1024),
    sort_order integer not null,
    enabled varchar(1) default 'N' not null,
    read_only varchar(1) default 'N' not null,
    login_module varchar(1024) not null,
    sec_authorization_realm_id varchar(36) not null,
    ghosted_date bigint default 0 not null,
    allowed_attempts integer default 0 not null,
    primary key (id)
);

create table sec_authentication_realm_prop (
    sec_authentication_realm_id varchar(36) not null,
    name varchar(1024) not null,
    value varchar(4000)
);

create table sec_authorization_realm (
    id varchar(36) not null,
    version integer default 0 not null,
    name varchar(64) not null,
    description varchar(1024),
    authorization_module varchar(1024) not null,
    primary key (id)
);

create table sec_authorization_realm_prop (
    sec_authorization_realm_id varchar(36) not null,
    name varchar(1024) not null,
    value varchar(4000)
);

create table sec_group (
    id varchar(36) not null,
    version integer default 0 not null,
    name varchar(255) not null,
    sec_authorization_realm_id varchar(36) not null,
    enabled varchar(1) default 'Y' not null,
    primary key (id)
);

create table sec_group_mapper (
    id varchar(36) not null,
    version integer default 0 not null,
    name varchar(64) not null unique,
    primary key (id)
);

create table sec_group_mapping (
    id varchar(36) not null,
    version integer default 0 not null,
    sec_group_mapper_id varchar(36) not null,
    regex varchar(255) not null,
    replacement varchar(255) not null,
    primary key (id)
);

create table sec_group_role_on_team (
    id varchar(36) not null,
    version integer default 0 not null,
    sec_group_id varchar(36) not null,
    sec_role_id varchar(36) not null,
    sec_team_space_id varchar(36) not null,
    primary key (id)
);

create table sec_internal_user (
    id varchar(36) not null,
    version integer default 0 not null,
    name varchar(64) not null,
    password varchar(128) not null,
    encoded smallint default 0 not null,
    primary key (id)
);

create table sec_resource (
    id varchar(36) not null,
    version integer default 0 not null,
    name varchar(255) not null,
    enabled varchar(1) default 'Y' not null,
    sec_resource_type_id varchar(36) not null,
    primary key (id)
);

create table sec_resource_for_team (
    id varchar(36) not null,
    version integer default 0 not null,
    sec_resource_id varchar(36) not null,
    sec_team_space_id varchar(36) not null,
    sec_resource_role_id varchar(36),
    primary key (id)
);

create table sec_resource_hierarchy (
    parent_sec_resource_id varchar(36) not null,
    child_sec_resource_id varchar(36) not null,
    path_length integer not null,
    primary key (parent_sec_resource_id, child_sec_resource_id)
);

create table sec_resource_role (
    id varchar(36) not null,
    version integer default 0 not null,
    name varchar(255) not null,
    description varchar(1024),
    enabled varchar(1) default 'Y' not null,
    sec_resource_type_id varchar(36) not null,
    primary key (id)
);

create table sec_resource_type (
    id varchar(36) not null,
    version integer default 0 not null,
    name varchar(255) not null,
    enabled varchar(1) default 'Y' not null,
    primary key (id)
);

create table sec_role (
    id varchar(36) not null,
    version integer default 0 not null,
    name varchar(255) not null,
    description varchar(1024),
    enabled varchar(1) default 'Y' not null,
    primary key (id)
);

create table sec_role_action (
    id varchar(36) not null,
    version integer default 0 not null,
    sec_role_id varchar(36) not null,
    sec_action_id varchar(36) not null,
    sec_resource_role_id varchar(36),
    primary key (id)
);

create table sec_team_space (
    id varchar(36) not null,
    version integer default 0 not null,
    enabled varchar(1) default 'Y' not null,
    name varchar(255) not null,
    description varchar(4000),
    primary key (id)
);

create table sec_user (
    id varchar(36) not null,
    version integer default 0 not null,
    name varchar(255) not null,
    enabled varchar(1) default 'Y' not null,
    password varchar(255),
    actual_name varchar(255),
    email varchar(255),
    im_id varchar(255),
    sec_authentication_realm_id varchar(36) not null,
    ghosted_date bigint default 0 not null,
    failed_attempts integer default 0 not null,
    sec_license_type_id_requested varchar(36),
    sec_license_type_id_received varchar(36),
    licensed_session_count integer default 0 not null,
    primary key (id)
);

create table sec_user_property (
    id varchar(36) not null,
    version integer default 0 not null,
    name varchar(255) not null,
    value varchar(4000),
    sec_user_id varchar(36) not null,
    primary key (id)
);

create table sec_user_role_on_team (
    id varchar(36) not null,
    version integer default 0 not null,
    sec_user_id varchar(36) not null,
    sec_role_id varchar(36) not null,
    sec_team_space_id varchar(36) not null,
    primary key (id)
);

create table sec_user_to_group (
    sec_user_id varchar(36) not null,
    sec_group_id varchar(36) not null
);

create table sec_license_type (
     id varchar(36) not null,
     version integer default 0 not null,
     feature varchar(36) not null,
     is_reservable varchar(1) default 'N' not null,
     primary key (id));
     
create table sec_action_to_license_type (
    action_id varchar(36) not null,
    license_type_id varchar(36) not null
);
