// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetLayoutSettingsCollection on Isar {
  IsarCollection<LayoutSettings> get layoutSettings => this.collection();
}

const LayoutSettingsSchema = CollectionSchema(
  name: r'LayoutSettings',
  id: 3559033267585353040,
  properties: {
    r'additionalDockRow': PropertySchema(
      id: 0,
      name: r'additionalDockRow',
      type: IsarType.bool,
    ),
    r'appDrawerColumns': PropertySchema(
      id: 1,
      name: r'appDrawerColumns',
      type: IsarType.long,
    ),
    r'appGridColumns': PropertySchema(
      id: 2,
      name: r'appGridColumns',
      type: IsarType.long,
    ),
    r'appGridRows': PropertySchema(
      id: 3,
      name: r'appGridRows',
      type: IsarType.long,
    ),
    r'dockColumns': PropertySchema(
      id: 4,
      name: r'dockColumns',
      type: IsarType.long,
    ),
    r'topDock': PropertySchema(
      id: 5,
      name: r'topDock',
      type: IsarType.bool,
    )
  },
  estimateSize: _layoutSettingsEstimateSize,
  serialize: _layoutSettingsSerialize,
  deserialize: _layoutSettingsDeserialize,
  deserializeProp: _layoutSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _layoutSettingsGetId,
  getLinks: _layoutSettingsGetLinks,
  attach: _layoutSettingsAttach,
  version: '3.0.5',
);

int _layoutSettingsEstimateSize(
  LayoutSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _layoutSettingsSerialize(
  LayoutSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.additionalDockRow);
  writer.writeLong(offsets[1], object.appDrawerColumns);
  writer.writeLong(offsets[2], object.appGridColumns);
  writer.writeLong(offsets[3], object.appGridRows);
  writer.writeLong(offsets[4], object.dockColumns);
  writer.writeBool(offsets[5], object.topDock);
}

LayoutSettings _layoutSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LayoutSettings(
    additionalDockRow: reader.readBoolOrNull(offsets[0]) ?? false,
    appDrawerColumns: reader.readLongOrNull(offsets[1]) ?? 3,
    appGridColumns: reader.readLongOrNull(offsets[2]) ?? 4,
    appGridRows: reader.readLongOrNull(offsets[3]) ?? 5,
    dockColumns: reader.readLongOrNull(offsets[4]) ?? 4,
    topDock: reader.readBoolOrNull(offsets[5]) ?? false,
  );
  object.id = id;
  return object;
}

P _layoutSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 3) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 4) as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 5) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 4) as P;
    case 5:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _layoutSettingsGetId(LayoutSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _layoutSettingsGetLinks(LayoutSettings object) {
  return [];
}

void _layoutSettingsAttach(
    IsarCollection<dynamic> col, Id id, LayoutSettings object) {
  object.id = id;
}

extension LayoutSettingsQueryWhereSort
    on QueryBuilder<LayoutSettings, LayoutSettings, QWhere> {
  QueryBuilder<LayoutSettings, LayoutSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LayoutSettingsQueryWhere
    on QueryBuilder<LayoutSettings, LayoutSettings, QWhereClause> {
  QueryBuilder<LayoutSettings, LayoutSettings, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterWhereClause> idBetween(
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

extension LayoutSettingsQueryFilter
    on QueryBuilder<LayoutSettings, LayoutSettings, QFilterCondition> {
  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      additionalDockRowEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'additionalDockRow',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      appDrawerColumnsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appDrawerColumns',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      appDrawerColumnsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appDrawerColumns',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      appDrawerColumnsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appDrawerColumns',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      appDrawerColumnsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appDrawerColumns',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      appGridColumnsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appGridColumns',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      appGridColumnsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appGridColumns',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      appGridColumnsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appGridColumns',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      appGridColumnsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appGridColumns',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      appGridRowsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appGridRows',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      appGridRowsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'appGridRows',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      appGridRowsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'appGridRows',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      appGridRowsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'appGridRows',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      dockColumnsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dockColumns',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      dockColumnsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dockColumns',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      dockColumnsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dockColumns',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      dockColumnsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dockColumns',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterFilterCondition>
      topDockEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topDock',
        value: value,
      ));
    });
  }
}

extension LayoutSettingsQueryObject
    on QueryBuilder<LayoutSettings, LayoutSettings, QFilterCondition> {}

extension LayoutSettingsQueryLinks
    on QueryBuilder<LayoutSettings, LayoutSettings, QFilterCondition> {}

extension LayoutSettingsQuerySortBy
    on QueryBuilder<LayoutSettings, LayoutSettings, QSortBy> {
  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      sortByAdditionalDockRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'additionalDockRow', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      sortByAdditionalDockRowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'additionalDockRow', Sort.desc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      sortByAppDrawerColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appDrawerColumns', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      sortByAppDrawerColumnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appDrawerColumns', Sort.desc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      sortByAppGridColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appGridColumns', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      sortByAppGridColumnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appGridColumns', Sort.desc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      sortByAppGridRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appGridRows', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      sortByAppGridRowsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appGridRows', Sort.desc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      sortByDockColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dockColumns', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      sortByDockColumnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dockColumns', Sort.desc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy> sortByTopDock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topDock', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      sortByTopDockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topDock', Sort.desc);
    });
  }
}

extension LayoutSettingsQuerySortThenBy
    on QueryBuilder<LayoutSettings, LayoutSettings, QSortThenBy> {
  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      thenByAdditionalDockRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'additionalDockRow', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      thenByAdditionalDockRowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'additionalDockRow', Sort.desc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      thenByAppDrawerColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appDrawerColumns', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      thenByAppDrawerColumnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appDrawerColumns', Sort.desc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      thenByAppGridColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appGridColumns', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      thenByAppGridColumnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appGridColumns', Sort.desc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      thenByAppGridRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appGridRows', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      thenByAppGridRowsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appGridRows', Sort.desc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      thenByDockColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dockColumns', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      thenByDockColumnsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dockColumns', Sort.desc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy> thenByTopDock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topDock', Sort.asc);
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QAfterSortBy>
      thenByTopDockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topDock', Sort.desc);
    });
  }
}

extension LayoutSettingsQueryWhereDistinct
    on QueryBuilder<LayoutSettings, LayoutSettings, QDistinct> {
  QueryBuilder<LayoutSettings, LayoutSettings, QDistinct>
      distinctByAdditionalDockRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'additionalDockRow');
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QDistinct>
      distinctByAppDrawerColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appDrawerColumns');
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QDistinct>
      distinctByAppGridColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appGridColumns');
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QDistinct>
      distinctByAppGridRows() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appGridRows');
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QDistinct>
      distinctByDockColumns() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dockColumns');
    });
  }

  QueryBuilder<LayoutSettings, LayoutSettings, QDistinct> distinctByTopDock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topDock');
    });
  }
}

extension LayoutSettingsQueryProperty
    on QueryBuilder<LayoutSettings, LayoutSettings, QQueryProperty> {
  QueryBuilder<LayoutSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LayoutSettings, bool, QQueryOperations>
      additionalDockRowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'additionalDockRow');
    });
  }

  QueryBuilder<LayoutSettings, int, QQueryOperations>
      appDrawerColumnsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appDrawerColumns');
    });
  }

  QueryBuilder<LayoutSettings, int, QQueryOperations> appGridColumnsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appGridColumns');
    });
  }

  QueryBuilder<LayoutSettings, int, QQueryOperations> appGridRowsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appGridRows');
    });
  }

  QueryBuilder<LayoutSettings, int, QQueryOperations> dockColumnsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dockColumns');
    });
  }

  QueryBuilder<LayoutSettings, bool, QQueryOperations> topDockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topDock');
    });
  }
}
