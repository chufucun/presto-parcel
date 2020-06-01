# presto-parcel
presto for Cloudera Manager parcel

# Build

```
mvn -Djdk.tar.gz.path=/your/path/to/jdk.tar.gz package
```

- By default, use `prestosql/presto` repository ( https://github.com/prestosql/presto )
- Properties
  - `jdk.tar.gz.path`: Path to your JDK file (required)
  - `presto.version`: Presto version (default: `306`)
  - `presto.url.base`: Presto's Maven URL (default: `https://repo1.maven.org/maven2/io/prestosql`)  
  - `additional.dir.path`: Path to the directory where additional files (Plugins, ...) are stored (default: none)


## Example

- Use `prestodb/presto` repository ( https://github.com/prestodb/presto ), and use Presto 0.218
```
mvn -Djdk.tar.gz.path=/your/path/to/jdk.tar.gz -Dpresto.url.base="https://repo1.maven.org/maven2/com/facebook/presto" -Dpresto.version=0.218 package
```

- Add Presto Plugin files (`/tmp/work/plugin/your-plugin/xxx.jar`), and use Presto 316
```
mvn -Djdk.tar.gz.path=/your/path/to/jdk.tar.gz -Dadditional.dir.path=/tmp/work -Dpresto.version=316 package
```

# Deploy

https://github.com/cloudera/cm_ext/wiki/The-parcel-repository-format#structure-of-a-parcel-repository

# About Presto

https://prestodb.io/

# About Cloudera Manager

http://www.cloudera.com/content/www/en-us/products/cloudera-manager.html

# About parcel

https://github.com/cloudera/cm_ext/wiki/Parcels%3A-What-and-Why%3F
