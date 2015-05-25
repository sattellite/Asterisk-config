# NAME

Asterisk::config - the Asterisk config read and write module.

# SYNOPSIS

```perl
use Asterisk::config;

my $sip_conf = new Asterisk::config(file=>'/etc/asterisk/sip.conf');
my $conference = new Asterisk::config(file=>'/etc/asterisk/meetme.conf',
                                          keep_resource_array=>0);

$allow = $sip_conf->fetch_values_arrayref(section=>'general',key=>'allow');
print $allow->[0];

$sip_conf->assign_append(point=>'down',data=>"[userb]\ntype=friend\n");

$sip_conf->save();
```

# DESCRIPTION

Asterisk::config can parse and saving data with Asterisk config files. this module support asterisk 1.0 1.2 1.4 1.6, and it also support Zaptel config files.

# Note

Version 0.9 syntax incompitable with 0.8.

# CLASS METHOD

## new

```perl
$sip_conf = new Asterisk::config(file=>'file name',
                                 [stream_data=>$string],
                                 [object variable]);
```

Instantiates a new object of file. Reads data from stream\_data or file.

# OBJECT VARIABLES

FIXME: should all of those be documented in the POD (rather than in comments in the code?)

## file

Config file name and path. Must be set. If file does exists (exp. data from `stream_data`), you will not be able to save using [save\_file](#save_file).

## keep\_resource\_array

use resource array when save make fast than open file, but need more memory, default enabled. use set\_objvar to change it.

## reload\_when\_save

When save done, auto call. Enabled by default. Use set\_variable to change it.
FIXME: what is `set_variable`?

## clean\_when\_reload

When reload done, auto clean\_assign with current object.

Enabled by default. Use [set\_objvar](#set_objvar) to change it.

## commit\_list

Internal variable listed all command.

## parsed\_conf

Internal variable of parsed.

# OBJECT READ METHOD

## get\_objvar

```perl
$sip_conf->get_objvar(var_name);
```

Return defined object variables.

## fetch\_sections\_list

```perl
$sip_conf->fetch_sections_list();
```

List of sections (not including `unsection`) in a file.

## fetch\_sections\_hashref

```perl
$sip_conf->fetch_sections_hashref();
```

Returns the config file parsed as a hash (section name -> section) of lists (list of lines).

## fetch\_keys\_list

```perl
$sip_conf->fetch_keys_list(section=>[section name|unsection]);
```

Returns list of the kes in the keys in _section name_ (or _unsection_).

## fetch\_keys\_hashref

```perl
$sip_conf->fetch_keys_hashref(section=>[section name|unsection]);
```

Returns the section as a hash of key=>value pairs.

## fetch\_values\_arrayref

```perl
$sip_conf->fetch_values_arrayref(section=>[section name|unsection], key=>key name);
```

Returns a (reference to a) list of all the values a specific keys have in a specific section. referenced value list, Returns 0 if section was not found or key was not found in the section.

## reload

```perl
$sip_conf->reload();
```

Reloads and parses the config file.

If [clean\_when\_reload](#clean_when_reload) is true, will also do [clean\_assign](#clean_assign).

# OBJECT WRITE METHOD

## set\_objvar

```perl
$sip_conf->set_objvar('var_name'=>'value');
```

Set the object variables to new value.

## assign\_cleanfile

```
$sip_conf->assign_cleanfile();
```

Resets all the non-saved changes (from other assign\_\* functions).

## assign\_matchreplace

```perl
$sip_conf->assign_matchreplace(section => [section name],
                               match   => [string],
                               replace => [string]);
```

replace new data when matched. Will be replace matched lines only in one section if section is defined.

- match -> string of matched data.
- replace -> new data string.

## assign\_append

Used to add extra data to an existing section or to edit it.

```perl
$sip_conf->assign_append(point=>['up'|'down'|'foot'],
                         section=>[section name],
                         data=>'key=value'|['key=value','key=value']|{key=>'value',key=>'value'});
```

This form is used to merely append new data.

- point

    Append data `up` / `down` / `foot` with section.

- section

    Matched section name, expect 'unsection'. If ommited, data will be placed above first setcion, as in 'unsection', but then you cannot use `point=`"foot".

- data

    New replace data in string/array/hash.

```perl
$sip_conf->assign_append(point=>['up'|'down'|'over'],
                         section=>[section name],
                         comkey=>[key,value],
                         data=>'key=value'|['key=value','key=value']|{key=>'value',key=>'value'};
```

Appends data before, after or instead a given line. The line is the first line in `section` where the key is `key` and the value is `value` (from `comkey`.

- point

    `over` will overwrite with key/value matched.

- comkey

    Match key and value.

## assign\_replacesection

```perl
$sip_conf->assign_replacesection(section=>[section name|unsection],
                         data=>'key=value'|['key=value','key=value']|{key=>'value',key=>'value'});
```

replace the section body data.

- section -> all section name and 'unsection'.

## assign\_delsection

```perl
$sip_conf->assign_delsection(section=>[section name|unsection]);
```

erase section name and section data.

- section -> all section and 'unsection'.

## assign\_addsection

```perl
$sip_conf->assign_addsection(section=>[section]);
```

add section with name.

- section -> name of new section.

## assign\_editkey

```perl
$sip_conf->assign_editkey(section=>[section name|unsection],key=>[keyname],value=>[value],new_value=>[new_value]);
$sip_conf->assign_editkey(section=>[section name|unsection],key=>[keyname],value_regexp=>[value],new_value=>[new_value]);
```

modify value with matched section. If don't assign value=> will replace all matched key.

warnning example script:

```perl
$sip_conf->assign_editkey(section=>'990001',key=>'all',new_value=>'gsm');
```

data:

```
all=g711
all=ilbc
```

will convert to:

```
all=gsm
all=gsm
```

## assign\_delkey

```perl
$sip_conf->assign_delkey(section=>[section name|unsection],key=>[keyname],value=>[value]);
```

erase all matched `keyname` in section or in 'unsection'.

```perl
$sip_conf->assign_delkey(section=>[section name|unsection],key=>[keyname],value_regexp=>[exten_number]);
```

erase when matched exten number.

```perl
exten => 100,n,...
exten => 102,n,...
```

## save\_file

```perl
$sip_conf->save_file([new_file=>'filename']);
```

Process commit list and save to file. If reload\_when\_save true will do reload. If no object variable file or file not exists or can't be save return failed. If defined new\_file will save to new file, default overwrite objvar 'file'.

## clean\_assign

```perl
$sip_conf->clean_assign();
```

clean all assign rules.

# EXAMPLES

see example in source tree.

# AUTHORS

Asterisk::config by Sun bing <hoowa.sun@gmail.com>

Version 0.7 patch by Liu Hailong.

# COPYRIGHT

The Asterisk::config module is Copyright (c) Sun bing <hoowa.sun@gmail.com>
All rights reserved.

You may distribute under the terms of either the GNU General Public License or the Artistic License, as specified in the Perl README file.

# WARRANTY

The Asterisk::config is free Open Source software.

IT COMES WITHOUT WARRANTY OF ANY KIND.

# SUPPORT

Sun bing <hoowa.sun@gmail.com> don't update this module since 1 Jun 2009. He didn't answer by email and didn't apply patches during the year.

Alexander Groshev <null@sattellite.me> supports this fork.

The Asterisk::config be Part of FreeIris opensource Telephony Project Access http://www.freeiris.org for more details.
