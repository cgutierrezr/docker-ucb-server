/*
 * Licensed Materials - Property of IBM Corp.
 * IBM UrbanCode Build
 * IBM UrbanCode Deploy
 * IBM UrbanCode Release
 * IBM AnthillPro
 * (c) Copyright IBM Corporation 2002, 2014. All Rights Reserved.
 *
 * U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by
 * GSA ADP Schedule Contract with IBM Corp.
 */
import groovy.sql.Sql;

import java.io.*;
import java.lang.*;
import java.sql.Connection;
import java.util.*;

// login information for database
// this should be modified as need be
Hashtable properties = (Hashtable) this.getBinding().getVariable("ANT_PROPERTIES");
Connection connection = (Connection) this.getBinding().getVariable("CONN");
boolean verbose = Boolean.valueOf(properties.get("verbose")).booleanValue();
Sql sql = new Sql(connection)
//------------------------------------------------------------------------------
//utility methods

error = { message ->
  println("!!"+message);
}

warn = { message ->
  println("warn - "+message);
}

debug = { message ->
  if (verbose) {
    println(message);
  }
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
sql.connection.autoCommit = false;

String drop_auth_token_uc_index = "drop index sec_auth_token_uc"
String drop_auth_token_uc_constraint = "alter table sec_auth_token drop constraint sec_auth_token_uc"

try {
    sql.execute(drop_auth_token_uc_constraint)
}
catch (Exception e) {
    warn(e)
}

try {
    sql.execute(drop_auth_token_uc_index)
}
catch (Exception e) {
    warn(e)
}