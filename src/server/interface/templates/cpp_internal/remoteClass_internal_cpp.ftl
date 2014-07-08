${remoteClass.name}Internal.cpp
/* Autogenerated with Kurento Idl */

#include "${remoteClass.name}Internal.hpp"
#include <KurentoException.hpp>
#include <jsonrpc/JsonSerializer.hpp>
<#list remoteClassDependencies(remoteClass) as dependency>
#include "${dependency.name}.hpp"
</#list>

namespace kurento
{

<#list remoteClass.methods as method><#rt>
${getCppObjectType(method.return, false)} ${remoteClass.name}Method${method.name?cap_first}::invoke (std::shared_ptr<${remoteClass.name}> obj)
{
  if (!obj) {
    throw KurentoException (MEDIA_OBJECT_NOT_FOUND, "Invalid object while invoking method ${remoteClass.name}::${method.name}");
  }

  <#list method.params as param>
  <#if param.optional>
  <#assign optionalParam = param>
  if (!__isSet${param.name?cap_first}) {
    return obj->${method.name} (<#rt>
    <#lt><#list method.params as param>
      <#lt><#if optionalParam == param><#break></#if><#if param_index != 0>, </#if>${param.name}<#rt>
    <#lt></#list>);
  }

  </#if>
  </#list>
  return obj->${method.name} (<#rt>
    <#lt><#list method.params as param>
      <#lt><#if param_index != 0>, </#if>${param.name}<#rt>
    <#lt></#list>);
}

void ${remoteClass.name}Method${method.name?cap_first}::Serialize (JsonSerializer &s)
{
  if (s.IsWriter) {
  <#list method.params as param>
    <#if param.optional>
    if (__isSet${param.name?cap_first}) {
      s.SerializeNVP (${param.name});
    }

    <#else>
    s.SerializeNVP (${param.name});

    </#if>
  </#list>
  } else {
  <#list method.params as param>
    <#assign jsonData = getJsonCppTypeData(param.type)>
    <#if param.optional>
    if (s.JsonValue.isMember ("${param.name}") ) {
      if (s.JsonValue["${param.name}"].isConvertibleTo (Json::ValueType::${jsonData.getJsonValueType()}) ) {
        __isSet${param.name?cap_first} = true;
        s.SerializeNVP (${param.name});
      } else {
        throw KurentoException (MARSHALL_ERROR,
                                "'${param.name}' parameter should be a ${jsonData.getTypeDescription()}");
      }
    }

    <#else>
    if (!s.JsonValue.isMember ("${param.name}") || !s.JsonValue["${param.name}"].isConvertibleTo (Json::ValueType::${jsonData.getJsonValueType()}) ) {
      throw KurentoException (MARSHALL_ERROR,
                              "'${param.name}' parameter should be a ${jsonData.getTypeDescription()}");
    }

    s.SerializeNVP (${param.name});

    </#if>
  </#list>
  }
}

</#list>
<#if remoteClass.constructor??><#rt>
<#list remoteClass.constructor.params as param>
${getCppObjectType (param.type, false)} ${remoteClass.name}Constructor::get${param.name?cap_first} ()
{
  <#if param.optional>
  <#if param.defaultValue?? >
  if (!__isSet${param.name?cap_first} && !__isSetDefault${param.name?cap_first}) {
    try {
      JsonSerializer s (false);
      Json::Reader reader;
      std::string defaultValue = "${escapeString (param.defaultValue)}";

      reader.parse (defaultValue, s.JsonValue["${param.name}"]);
      s.SerializeNVP (${param.name});
      __isSetDefault${param.name?cap_first} = true;
    } catch (std::exception &e) {
      std::cerr << "Unexpected exception deserializing default value ${param.name} of ${remoteClass.name} constructor, check your model: " << e.what() << std::endl;
    }
  }

  <#else>
#error "${param.name} optional param must have a default value"
  </#if>
  </#if>
  return ${param.name};
}

</#list>
void ${remoteClass.name}Constructor::Serialize (JsonSerializer &s)
{
  if (s.IsWriter) {
  <#list remoteClass.constructor.params as param>
    <#if param.optional>
    if (__isSet${param.name?cap_first}) {
      s.SerializeNVP (${param.name});
    }

    <#else>
    s.SerializeNVP (${param.name});

    </#if>
  </#list>
  } else {
  <#list remoteClass.constructor.params as param>
    <#assign jsonData = getJsonCppTypeData(param.type)>
    <#if param.optional>
    if (s.JsonValue.isMember ("${param.name}") ) {
      if (s.JsonValue["${param.name}"].isConvertibleTo (Json::ValueType::${jsonData.getJsonValueType()}) ) {
        __isSet${param.name?cap_first} = true;
        s.SerializeNVP (${param.name});
      } else {
        throw KurentoException (MARSHALL_ERROR,
                                "'${param.name}' parameter should be a ${jsonData.getTypeDescription()}");
      }
    }

    <#else>
    if (!s.JsonValue.isMember ("${param.name}") || !s.JsonValue["${param.name}"].isConvertibleTo (Json::ValueType::${jsonData.getJsonValueType()}) ) {
      throw KurentoException (MARSHALL_ERROR,
                              "'${param.name}' parameter should be a ${jsonData.getTypeDescription()}");
    }

    s.SerializeNVP (${param.name});

    </#if>
  </#list>
  }
}

</#if>
} /* kurento */
