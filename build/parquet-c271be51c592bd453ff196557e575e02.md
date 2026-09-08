---
title: Apache Parquet Format
description: Comprehensive guide to Apache Parquet columnar storage format, architecture, use cases, and ecosystem integration
---

# Apache Parquet

## Overview

Apache Parquet is an open-source, columnar file format optimized for storing and processing large datasets in analytical systems. Unlike traditional row-based formats such as CSV, Parquet organizes data by columns, offering significant advantages for big data applications.

Parquet was originally developed at Twitter and Cloudera and is now a cornerstone of modern data platforms, serving as the foundation for data lakes, data warehouses, and lakehouse architectures.

---

## Key Features & Benefits

### Columnar Storage

Data is stored vertically by column rather than horizontally by row. This design is ideal for analytical queries that typically access only a small subset of columns from large tables.

**Benefits:**
- Query engines read only required columns, minimizing I/O
- Dramatically reduced bandwidth requirements
- Faster query execution for column-specific analysis

**Example:** Querying 5 columns from a 100-column table reads only ~5% of data instead of 100%.

### Efficient Compression

Grouping similar data types together in columns enables significantly higher compression ratios than row-oriented formats.

**Supported Algorithms:**
- **Snappy:** Fast compression with reasonable ratios; default in many systems
- **Gzip:** Higher compression but slower; good for storage optimization
- **Zstandard (Zstd):** Modern algorithm with excellent compression/speed trade-off
- **LZO, Brotli:** Legacy and specialized algorithms

**Impact:**
- 5-10x smaller file sizes compared to CSV
- Reduced storage costs
- Faster network transfers
- Lower bandwidth consumption

### Performance Optimization

#### Predicate Pushdown

Parquet stores metadata including column statistics (min/max values, null counts). Query engines use these statistics to filter data at the storage level before reading into memory.

**Process:**
1. Query engine evaluates WHERE clause
2. Checks column metadata against filter conditions
3. Skips row groups (data chunks) that don't match criteria
4. Only reads relevant data blocks

**Performance Gain:** 10-100x faster for selective queries

#### Vectorized Reads

Parquet is optimized for batch processing (vectors) instead of row-by-row reads, making efficient use of modern CPU SIMD instructions.

**Benefits:**
- Better cache utilization
- Fewer CPU cycles per record
- Parallelizable operations
- Faster overall throughput

### Self-Describing Format

Each Parquet file contains embedded metadata:

```
┌─────────────────────────────┐
│   Data Block 1              │
├─────────────────────────────┤
│   Data Block 2              │
├─────────────────────────────┤
│   Data Block 3              │
├─────────────────────────────┤
│   Footer (Metadata)         │
│   - Schema                  │
│   - Column Statistics       │
│   - Row Group Info          │
│   - Compression Details     │
└─────────────────────────────┘
```

**Advantages:**
- Tools interpret data without external schema
- Improved data integrity
- Self-contained datasets
- Easier data sharing and discovery

### Complex Data Types Support

Parquet natively handles nested structures:

- **Nested objects:** Structs with multiple fields
- **Arrays & Lists:** Repeated field types
- **Maps:** Key-value pairs
- **Deep nesting:** Multiple levels of nesting

**Example:**
```json
{
  "user_id": 123,
  "name": "John Doe",
  "addresses": [
    {"street": "Main St", "city": "NYC"},
    {"street": "Oak Ave", "city": "LA"}
  ],
  "preferences": {"theme": "dark", "language": "en"}
}
```

CSV cannot represent this directly; Parquet handles it natively.

### Ecosystem Support

Parquet is supported by a comprehensive ecosystem:

#### Processing Engines
- **Apache Spark:** Native Parquet support with optimized I/O
- **Apache Hadoop:** Via MapReduce and Hive
- **Apache Hive:** SQL queries on Parquet tables
- **Presto/Trino:** Fast SQL queries across Parquet datasets
- **DuckDB:** In-process OLAP engine with excellent Parquet support
- **Pandas/PyArrow:** Python data manipulation

#### Cloud Storage & Services
- **Amazon S3:** S3 Select for server-side filtering
- **Google Cloud Storage:** Native Parquet handling
- **Azure Data Lake Storage (ADLS):** Enterprise data lakes
- **Snowflake:** Native Parquet support with automatic optimization

#### Data Lakehouse Architectures
- **Delta Lake:** Transactional layer on top of Parquet
- **Apache Iceberg:** Modern table format using Parquet
- **Apache Hudi:** Incremental processing with Parquet storage

---

## Parquet vs. CSV

| Feature | Parquet | CSV |
|---------|---------|-----|
| **Storage Model** | Column-oriented | Row-oriented |
| **File Structure** | Binary format, not human-readable | Plain text, human-readable |
| **Storage Efficiency** | Highly efficient; 5-10x compression | Inefficient; all data stored as text |
| **Query Performance** | Much faster; reads only needed columns; predicate pushdown | Slow; must read all rows regardless of query |
| **Schema** | Embedded metadata for schema | No schema; requires external definition |
| **Data Types** | Supports complex & nested structures | Flat structure only |
| **Compression** | Multiple algorithms; very effective | Text encoding only |
| **Parsing Overhead** | Lower; binary format | Higher; text parsing required |
| **File Size (1GB data)** | ~100-200 MB | ~1 GB |
| **Query Time (5 cols)** | ~100ms | ~5000ms |

### Performance Comparison Example

**Scenario:** Query 5 columns from 100-column dataset with 1 billion rows

```
CSV Approach:
├─ Read entire file: 1 GB → 5000ms
├─ Parse text: 2000ms
├─ Filter rows: 1000ms
└─ Total: ~8000ms

Parquet Approach:
├─ Read metadata: 10ms
├─ Check predicate: 5ms
├─ Skip unneeded data: (skipped)
├─ Read 5 columns: 100ms
├─ Filter rows: 50ms
└─ Total: ~165ms
```

**Result:** Parquet is ~50x faster

---

## File Format Structure

### Parquet File Layout

```
Row Group 1
├─ Column 1 Data + Stats
├─ Column 2 Data + Stats
└─ Column N Data + Stats

Row Group 2
├─ Column 1 Data + Stats
├─ Column 2 Data + Stats
└─ Column N Data + Stats

Metadata Footer
├─ Schema Definition
├─ Row Group Metadata
├─ Column Metadata (per row group)
├─ Created By / Version
└─ File Length Reference
```

### Key Concepts

**Row Group:** Logical division of rows (e.g., 128 MB chunks). Each row group is independently readable.

**Column Chunk:** Stores all values for one column within a row group. Compressed independently.

**Page:** Smallest independently readable unit within a column chunk (typically 1-8 MB).

**Metadata:**
- **File metadata:** Schema, version, created time
- **Row group metadata:** Number of rows, file positions
- **Column metadata:** Min/max values, distinct counts, null counts

---

## Common Use Cases

### Data Lakes

Parquet is the de facto standard for modern data lake architectures.

**Why:**
- High compression reduces storage costs by 80-90%
- Fast queries enable self-service analytics
- Metadata enables automated data discovery
- Scales to petabytes with consistent performance

**Typical Setup:**
```
S3 / ADLS / GCS (Data Lake)
└─ Parquet Files
   ├─ Sales Data (Year 2024)
   ├─ Customer Data
   └─ Product Catalog
   
Query engines (Spark, Presto, DuckDB)
└─ Read Parquet, apply filters, return results
```

### Analytical Workloads (OLAP)

Ideal for Online Analytical Processing and Business Intelligence.

**Characteristics:**
- Complex ad hoc queries
- Aggregations across large datasets
- Selective column access
- Occasional full-table scans

**Example Queries:**
```sql
-- Column selection + aggregation
SELECT region, SUM(revenue), AVG(quantity)
FROM sales_parquet
WHERE date >= '2024-01-01'
GROUP BY region;

-- Parquet advantage: Reads only region, revenue, quantity, date columns
-- CSV: Must read all columns
```

### Batch Processing

Standard format for data pipelines and ETL jobs.

**Frameworks:**
- **Apache Spark:** Batch data processing and machine learning
- **Apache Hadoop:** MapReduce jobs
- **Apache Airflow:** Orchestrated data pipelines
- **dbt:** Data transformation workflows

**Workflow:**
```
1. Ingest raw data (CSV/JSON) → Parquet
2. Transform/Clean in Spark
3. Write results as Parquet
4. Query via Presto/Trino
5. Visualize in BI tools
```

### Machine Learning Feature Stores

Used by ML platforms to store features efficiently.

**Use Cases:**
- Feature materialization
- Point-in-time lookups
- Large-scale feature engineering
- Real-time feature serving (with caching)

### Time Series Data

Excellent for time series analytics with timestamp partitioning.

**Example:**
```
metrics/
├─ 2024-01-01/
│  └─ events.parquet
├─ 2024-01-02/
│  └─ events.parquet
└─ 2024-01-03/
   └─ events.parquet
```

Benefits:
- Query specific date ranges efficiently
- Partition pruning skips irrelevant dates
- Compress based on timestamp locality

---

## Working with Parquet

### Python (PyArrow)

```python
import pyarrow.parquet as pq
import pandas as pd

# Read entire Parquet file
table = pq.read_table('data.parquet')
df = table.to_pandas()

# Read specific columns
df = pd.read_parquet('data.parquet', columns=['name', 'email'])

# Read with filtering
table = pq.read_table('data.parquet',
                      filters=[('age', '>=', 18)])

# Write DataFrame as Parquet
df.to_parquet('output.parquet', compression='snappy')

# Inspect schema and metadata
parquet_file = pq.ParquetFile('data.parquet')
print(parquet_file.schema)
print(parquet_file.metadata)
```

### Python (PySpark)

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName('parquet-demo').getOrCreate()

# Read Parquet
df = spark.read.parquet('data.parquet')

# Read with column selection
df = spark.read.parquet('data.parquet').select('name', 'email')

# Read with filtering (predicate pushdown)
df = spark.read.parquet('data.parquet').filter(df.age >= 18)

# Write as Parquet
df.write.parquet('output.parquet', mode='overwrite')

# Partitioned write
df.write.partitionBy('year', 'month').parquet('output/')
```

### SQL (Presto/Trino)

```sql
-- Query Parquet files
SELECT name, COUNT(*) as count
FROM "s3:///data-lake/events/*.parquet"
WHERE date >= '2024-01-01'
GROUP BY name;

-- Create table from Parquet
CREATE TABLE events AS
SELECT * FROM "s3:///raw/events.parquet";

-- Query with column selection (automatic pushdown)
SELECT user_id, revenue
FROM events
WHERE country = 'USA';
```

### Command Line (parquet-tools)

```bash
# Install
pip install parquet-tools

# Inspect schema
parquet-tools schema data.parquet

# View metadata
parquet-tools meta data.parquet

# Inspect row count
parquet-tools rowcount data.parquet

# Dump data
parquet-tools dump data.parquet | head -20
```

---

## Performance Best Practices

### 1. Compression Selection

| Compression | Ratio | Speed | Use Case |
|------------|-------|-------|----------|
| Uncompressed | 1x | Fastest | High I/O bandwidth |
| Snappy | ~2-3x | Fast | Default choice |
| Gzip | ~4-10x | Slow | Storage optimization |
| Zstd | ~3-8x | Medium | Balanced approach |

**Recommendation:** Use Snappy by default; switch to Zstd or Gzip for storage-constrained environments.

### 2. Row Group Size

Larger row groups = Better compression but more memory.

**Recommendations:**
- **Default (128 MB):** Good for most use cases
- **Larger (256-512 MB):** Higher compression for large datasets
- **Smaller (64 MB):** Limited memory environments

### 3. Column Ordering

Frequently filtered columns first improves predicate pushdown efficiency.

```python
# Good: Filter columns listed first
df[['date', 'country', 'user_id', 'amount']].to_parquet(...)

# Query filters efficiently on date/country
```

### 4. Partitioning Strategy

Partition large tables by frequently filtered columns.

```python
df.write \
  .partitionBy('year', 'month', 'country') \
  .mode('overwrite') \
  .parquet('s3://bucket/data/')
```

**Benefits:**
- Partition pruning skips irrelevant directories
- Parallelizes queries across partitions
- Enables efficient incremental updates

### 5. Monitoring & Diagnostics

```python
# Check file statistics
import pyarrow.parquet as pq

file = pq.ParquetFile('data.parquet')
meta = file.metadata
print(f"Num rows: {meta.num_rows}")
print(f"Num row groups: {meta.num_row_groups}")
print(f"Compression: {file.schema_arrow.pandas_metadata}")

# Check compression ratios
for i in range(meta.num_row_groups):
  rg = meta.row_group(i)
  total_bytes = rg.total_byte_size
  compressed_bytes = sum(
    rg.column(j).total_compressed_size 
    for j in range(rg.num_columns)
  )
  ratio = total_bytes / compressed_bytes
  print(f"Row group {i}: {ratio:.1f}x compression")
```

---

## Resource Links

- [Apache Parquet Official](https://parquet.apache.org/)
- [PyArrow Documentation](https://arrow.apache.org/docs/python/)
- [Parquet Format Specification](https://github.com/apache/parquet-format)
- [Delta Lake](https://delta.io/)
- [Apache Iceberg](https://iceberg.apache.org/)
