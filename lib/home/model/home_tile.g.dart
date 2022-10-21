// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_tile.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetHomeTileCollection on Isar {
  IsarCollection<HomeTile> get homeTiles => this.collection();
}

const HomeTileSchema = CollectionSchema(
  name: r'HomeTile',
  id: -7289812824508021333,
  properties: {
    r'appData': PropertySchema(
      id: 0,
      name: r'appData',
      type: IsarType.object,
      target: r'AppData',
    ),
    r'appWidgetData': PropertySchema(
      id: 1,
      name: r'appWidgetData',
      type: IsarType.object,
      target: r'AppWidgetData',
    ),
    r'column': PropertySchema(
      id: 2,
      name: r'column',
      type: IsarType.long,
    ),
    r'columnSpan': PropertySchema(
      id: 3,
      name: r'columnSpan',
      type: IsarType.long,
    ),
    r'page': PropertySchema(
      id: 4,
      name: r'page',
      type: IsarType.long,
    ),
    r'row': PropertySchema(
      id: 5,
      name: r'row',
      type: IsarType.long,
    ),
    r'rowSpan': PropertySchema(
      id: 6,
      name: r'rowSpan',
      type: IsarType.long,
    )
  },
  estimateSize: _homeTileEstimateSize,
  serialize: _homeTileSerialize,
  deserialize: _homeTileDeserialize,
  deserializeProp: _homeTileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'AppData': AppDataSchema,
    r'AppWidgetData': AppWidgetDataSchema
  },
  getId: _homeTileGetId,
  getLinks: _homeTileGetLinks,
  attach: _homeTileAttach,
  version: '3.0.2',
);

int _homeTileEstimateSize(
  HomeTile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.appData;
    if (value != null) {
      bytesCount += 3 +
          AppDataSchema.estimateSize(
              value, allOffsets[HomeTileAppData]!, allOffsets);
    }
  }
  {
    final value = object.appWidgetData;
    if (value != null) {
      bytesCount += 3 +
          AppWidgetDataSchema.estimateSize(
              value, allOffsets[HomeTileAppWidgetData]!, allOffsets);
    }
  }
  return bytesCount;
}

void _homeTileSerialize(
  HomeTile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<HomeTileAppData>(
    offsets[0],
    allOffsets,
    AppDataSchema.serialize,
    object.appData,
  );
  writer.writeObject<HomeTileAppWidgetData>(
    offsets[1],
    allOffsets,
    AppWidgetDataSchema.serialize,
    object.appWidgetData,
  );
  writer.writeLong(offsets[2], object.column);
  writer.writeLong(offsets[3], object.columnSpan);
  writer.writeLong(offsets[4], object.page);
  writer.writeLong(offsets[5], object.row);
  writer.writeLong(offsets[6], object.rowSpan);
}

HomeTile _homeTileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HomeTile();
  object.appData = reader.readObjectOrNull<HomeTileAppData>(
    offsets[0],
    AppDataSchema.deserialize,
    allOffsets,
  );
  object.appWidgetData = reader.readObjectOrNull<HomeTileAppWidgetData>(
    offsets[1],
    AppWidgetDataSchema.deserialize,
    allOffsets,
  );
  object.column = reader.readLongOrNull(offsets[2]);
  object.columnSpan = reader.readLongOrNull(offsets[3]);
  object.id = id;
  object.page = reader.readLongOrNull(offsets[4]);
  object.row = reader.readLongOrNull(offsets[5]);
  object.rowSpan = reader.readLongOrNull(offsets[6]);
  return object;
}

P _homeTileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<HomeTileAppData>(
        offset,
        AppDataSchema.deserialize,
        allOffsets,
      )) as P;
    case 1:
      return (reader.readObjectOrNull<HomeTileAppWidgetData>(
        offset,
        AppWidgetDataSchema.deserialize,
        allOffsets,
      )) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _homeTileGetId(HomeTile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _homeTileGetLinks(HomeTile object) {
  return [];
}

void _homeTileAttach(IsarCollection<dynamic> col, Id id, HomeTile object) {
  object.id = id;
}

extension HomeTileQueryWhereSort on QueryBuilder<HomeTile, HomeTile, QWhere> {
  QueryBuilder<HomeTile, HomeTile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HomeTileQueryWhere on QueryBuilder<HomeTile, HomeTile, QWhereClause> {
  QueryBuilder<HomeTile, HomeTile, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HomeTileQueryFilter
    on QueryBuilder<HomeTile, HomeTile, QFilterCondition> {
  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> appDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'appData',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> appDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'appData',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition>
      appWidgetDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'appWidgetData',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition>
      appWidgetDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'appWidgetData',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> columnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'column',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> columnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'column',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> columnEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'column',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> columnGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'column',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> columnLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'column',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> columnBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'column',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> columnSpanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'columnSpan',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition>
      columnSpanIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'columnSpan',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> columnSpanEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'columnSpan',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> columnSpanGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'columnSpan',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> columnSpanLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'columnSpan',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> columnSpanBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'columnSpan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> pageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'page',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> pageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'page',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> pageEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'page',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> pageGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'page',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> pageLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'page',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> pageBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'page',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> rowIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'row',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> rowIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'row',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> rowEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'row',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> rowGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'row',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> rowLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'row',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> rowBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'row',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> rowSpanIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rowSpan',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> rowSpanIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rowSpan',
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> rowSpanEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rowSpan',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> rowSpanGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rowSpan',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> rowSpanLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rowSpan',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> rowSpanBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rowSpan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HomeTileQueryObject
    on QueryBuilder<HomeTile, HomeTile, QFilterCondition> {
  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> appData(
      FilterQuery<HomeTileAppData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'appData');
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterFilterCondition> appWidgetData(
      FilterQuery<HomeTileAppWidgetData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'appWidgetData');
    });
  }
}

extension HomeTileQueryLinks
    on QueryBuilder<HomeTile, HomeTile, QFilterCondition> {}

extension HomeTileQuerySortBy on QueryBuilder<HomeTile, HomeTile, QSortBy> {
  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> sortByColumn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'column', Sort.asc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> sortByColumnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'column', Sort.desc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> sortByColumnSpan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnSpan', Sort.asc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> sortByColumnSpanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnSpan', Sort.desc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> sortByPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'page', Sort.asc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> sortByPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'page', Sort.desc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> sortByRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'row', Sort.asc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> sortByRowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'row', Sort.desc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> sortByRowSpan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rowSpan', Sort.asc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> sortByRowSpanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rowSpan', Sort.desc);
    });
  }
}

extension HomeTileQuerySortThenBy
    on QueryBuilder<HomeTile, HomeTile, QSortThenBy> {
  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> thenByColumn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'column', Sort.asc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> thenByColumnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'column', Sort.desc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> thenByColumnSpan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnSpan', Sort.asc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> thenByColumnSpanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnSpan', Sort.desc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> thenByPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'page', Sort.asc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> thenByPageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'page', Sort.desc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> thenByRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'row', Sort.asc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> thenByRowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'row', Sort.desc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> thenByRowSpan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rowSpan', Sort.asc);
    });
  }

  QueryBuilder<HomeTile, HomeTile, QAfterSortBy> thenByRowSpanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rowSpan', Sort.desc);
    });
  }
}

extension HomeTileQueryWhereDistinct
    on QueryBuilder<HomeTile, HomeTile, QDistinct> {
  QueryBuilder<HomeTile, HomeTile, QDistinct> distinctByColumn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'column');
    });
  }

  QueryBuilder<HomeTile, HomeTile, QDistinct> distinctByColumnSpan() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'columnSpan');
    });
  }

  QueryBuilder<HomeTile, HomeTile, QDistinct> distinctByPage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'page');
    });
  }

  QueryBuilder<HomeTile, HomeTile, QDistinct> distinctByRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'row');
    });
  }

  QueryBuilder<HomeTile, HomeTile, QDistinct> distinctByRowSpan() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rowSpan');
    });
  }
}

extension HomeTileQueryProperty
    on QueryBuilder<HomeTile, HomeTile, QQueryProperty> {
  QueryBuilder<HomeTile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HomeTile, HomeTileAppData?, QQueryOperations> appDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appData');
    });
  }

  QueryBuilder<HomeTile, HomeTileAppWidgetData?, QQueryOperations>
      appWidgetDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appWidgetData');
    });
  }

  QueryBuilder<HomeTile, int?, QQueryOperations> columnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'column');
    });
  }

  QueryBuilder<HomeTile, int?, QQueryOperations> columnSpanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'columnSpan');
    });
  }

  QueryBuilder<HomeTile, int?, QQueryOperations> pageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'page');
    });
  }

  QueryBuilder<HomeTile, int?, QQueryOperations> rowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'row');
    });
  }

  QueryBuilder<HomeTile, int?, QQueryOperations> rowSpanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rowSpan');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const AppDataSchema = Schema(
  name: r'AppData',
  id: 3950144987861183497,
  properties: {
    r'packageName': PropertySchema(
      id: 0,
      name: r'packageName',
      type: IsarType.string,
    )
  },
  estimateSize: _appDataEstimateSize,
  serialize: _appDataSerialize,
  deserialize: _appDataDeserialize,
  deserializeProp: _appDataDeserializeProp,
);

int _appDataEstimateSize(
  HomeTileAppData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.packageName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appDataSerialize(
  HomeTileAppData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.packageName);
}

HomeTileAppData _appDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HomeTileAppData(
    packageName: reader.readStringOrNull(offsets[0]),
  );
  return object;
}

P _appDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AppDataQueryFilter
    on QueryBuilder<HomeTileAppData, HomeTileAppData, QFilterCondition> {
  QueryBuilder<HomeTileAppData, HomeTileAppData, QAfterFilterCondition>
      packageNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'packageName',
      ));
    });
  }

  QueryBuilder<HomeTileAppData, HomeTileAppData, QAfterFilterCondition>
      packageNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'packageName',
      ));
    });
  }

  QueryBuilder<HomeTileAppData, HomeTileAppData, QAfterFilterCondition>
      packageNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppData, HomeTileAppData, QAfterFilterCondition>
      packageNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppData, HomeTileAppData, QAfterFilterCondition>
      packageNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppData, HomeTileAppData, QAfterFilterCondition>
      packageNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppData, HomeTileAppData, QAfterFilterCondition>
      packageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppData, HomeTileAppData, QAfterFilterCondition>
      packageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppData, HomeTileAppData, QAfterFilterCondition>
      packageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppData, HomeTileAppData, QAfterFilterCondition>
      packageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppData, HomeTileAppData, QAfterFilterCondition>
      packageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<HomeTileAppData, HomeTileAppData, QAfterFilterCondition>
      packageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'packageName',
        value: '',
      ));
    });
  }
}

extension AppDataQueryObject
    on QueryBuilder<HomeTileAppData, HomeTileAppData, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

const AppWidgetDataSchema = Schema(
  name: r'AppWidgetData',
  id: 5095303185153816698,
  properties: {
    r'appWidgetId': PropertySchema(
      id: 0,
      name: r'appWidgetId',
      type: IsarType.long,
    ),
    r'componentName': PropertySchema(
      id: 1,
      name: r'componentName',
      type: IsarType.string,
    )
  },
  estimateSize: _appWidgetDataEstimateSize,
  serialize: _appWidgetDataSerialize,
  deserialize: _appWidgetDataDeserialize,
  deserializeProp: _appWidgetDataDeserializeProp,
);

int _appWidgetDataEstimateSize(
  HomeTileAppWidgetData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.componentName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appWidgetDataSerialize(
  HomeTileAppWidgetData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.appWidgetId);
  writer.writeString(offsets[1], object.componentName);
}

HomeTileAppWidgetData _appWidgetDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HomeTileAppWidgetData(
    appWidgetId: reader.readLongOrNull(offsets[0]),
    componentName: reader.readStringOrNull(offsets[1]),
  );
  return object;
}

P _appWidgetDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AppWidgetDataQueryFilter on QueryBuilder<HomeTileAppWidgetData,
    HomeTileAppWidgetData, QFilterCondition> {
  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> appWidgetIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'appWidgetId',
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> appWidgetIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'appWidgetId',
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> appWidgetIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appWidgetId',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> appWidgetIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appWidgetId',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> appWidgetIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appWidgetId',
        value: value,
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> appWidgetIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appWidgetId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> componentNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'componentName',
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> componentNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'componentName',
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> componentNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'componentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> componentNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'componentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> componentNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'componentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> componentNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'componentName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> componentNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'componentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> componentNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'componentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
          QAfterFilterCondition>
      componentNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'componentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
          QAfterFilterCondition>
      componentNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'componentName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> componentNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'componentName',
        value: '',
      ));
    });
  }

  QueryBuilder<HomeTileAppWidgetData, HomeTileAppWidgetData,
      QAfterFilterCondition> componentNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'componentName',
        value: '',
      ));
    });
  }
}

extension AppWidgetDataQueryObject on QueryBuilder<HomeTileAppWidgetData,
    HomeTileAppWidgetData, QFilterCondition> {}
