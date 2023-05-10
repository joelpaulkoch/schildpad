// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tile.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTileCollection on Isar {
  IsarCollection<Tile> get tiles => this.collection();
}

const TileSchema = CollectionSchema(
  name: r'Tile',
  id: 7333498075616056013,
  properties: {
    r'columnSpan': PropertySchema(
      id: 0,
      name: r'columnSpan',
      type: IsarType.long,
    ),
    r'coordinates': PropertySchema(
      id: 1,
      name: r'coordinates',
      type: IsarType.object,
      target: r'GlobalElementCoordinates',
    ),
    r'rowSpan': PropertySchema(
      id: 2,
      name: r'rowSpan',
      type: IsarType.long,
    ),
    r'tileData': PropertySchema(
      id: 3,
      name: r'tileData',
      type: IsarType.object,
      target: r'ElementData',
    )
  },
  estimateSize: _tileEstimateSize,
  serialize: _tileSerialize,
  deserialize: _tileDeserialize,
  deserializeProp: _tileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'GlobalElementCoordinates': GlobalElementCoordinatesSchema,
    r'ElementData': ElementDataSchema,
    r'AppData': AppDataSchema,
    r'AppWidgetData': AppWidgetDataSchema
  },
  getId: _tileGetId,
  getLinks: _tileGetLinks,
  attach: _tileAttach,
  version: '3.1.0+1',
);

int _tileEstimateSize(
  Tile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 +
      GlobalElementCoordinatesSchema.estimateSize(object.coordinates,
          allOffsets[GlobalElementCoordinates]!, allOffsets);
  {
    final value = object.tileData;
    if (value != null) {
      bytesCount += 3 +
          ElementDataSchema.estimateSize(
              value, allOffsets[ElementData]!, allOffsets);
    }
  }
  return bytesCount;
}

void _tileSerialize(
  Tile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.columnSpan);
  writer.writeObject<GlobalElementCoordinates>(
    offsets[1],
    allOffsets,
    GlobalElementCoordinatesSchema.serialize,
    object.coordinates,
  );
  writer.writeLong(offsets[2], object.rowSpan);
  writer.writeObject<ElementData>(
    offsets[3],
    allOffsets,
    ElementDataSchema.serialize,
    object.tileData,
  );
}

Tile _tileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Tile(
    columnSpan: reader.readLongOrNull(offsets[0]) ?? 1,
    coordinates: reader.readObjectOrNull<GlobalElementCoordinates>(
          offsets[1],
          GlobalElementCoordinatesSchema.deserialize,
          allOffsets,
        ) ??
        defaultCoordinates,
    rowSpan: reader.readLongOrNull(offsets[2]) ?? 1,
    tileData: reader.readObjectOrNull<ElementData>(
      offsets[3],
      ElementDataSchema.deserialize,
      allOffsets,
    ),
  );
  object.id = id;
  return object;
}

P _tileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 1:
      return (reader.readObjectOrNull<GlobalElementCoordinates>(
            offset,
            GlobalElementCoordinatesSchema.deserialize,
            allOffsets,
          ) ??
          defaultCoordinates) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 3:
      return (reader.readObjectOrNull<ElementData>(
        offset,
        ElementDataSchema.deserialize,
        allOffsets,
      )) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _tileGetId(Tile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tileGetLinks(Tile object) {
  return [];
}

void _tileAttach(IsarCollection<dynamic> col, Id id, Tile object) {
  object.id = id;
}

extension TileQueryWhereSort on QueryBuilder<Tile, Tile, QWhere> {
  QueryBuilder<Tile, Tile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TileQueryWhere on QueryBuilder<Tile, Tile, QWhereClause> {
  QueryBuilder<Tile, Tile, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Tile, Tile, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Tile, Tile, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Tile, Tile, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Tile, Tile, QAfterWhereClause> idBetween(
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

extension TileQueryFilter on QueryBuilder<Tile, Tile, QFilterCondition> {
  QueryBuilder<Tile, Tile, QAfterFilterCondition> columnSpanEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'columnSpan',
        value: value,
      ));
    });
  }

  QueryBuilder<Tile, Tile, QAfterFilterCondition> columnSpanGreaterThan(
    int value, {
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

  QueryBuilder<Tile, Tile, QAfterFilterCondition> columnSpanLessThan(
    int value, {
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

  QueryBuilder<Tile, Tile, QAfterFilterCondition> columnSpanBetween(
    int lower,
    int upper, {
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

  QueryBuilder<Tile, Tile, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Tile, Tile, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Tile, Tile, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Tile, Tile, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Tile, Tile, QAfterFilterCondition> rowSpanEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rowSpan',
        value: value,
      ));
    });
  }

  QueryBuilder<Tile, Tile, QAfterFilterCondition> rowSpanGreaterThan(
    int value, {
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

  QueryBuilder<Tile, Tile, QAfterFilterCondition> rowSpanLessThan(
    int value, {
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

  QueryBuilder<Tile, Tile, QAfterFilterCondition> rowSpanBetween(
    int lower,
    int upper, {
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

  QueryBuilder<Tile, Tile, QAfterFilterCondition> tileDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tileData',
      ));
    });
  }

  QueryBuilder<Tile, Tile, QAfterFilterCondition> tileDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tileData',
      ));
    });
  }
}

extension TileQueryObject on QueryBuilder<Tile, Tile, QFilterCondition> {
  QueryBuilder<Tile, Tile, QAfterFilterCondition> coordinates(
      FilterQuery<GlobalElementCoordinates> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'coordinates');
    });
  }

  QueryBuilder<Tile, Tile, QAfterFilterCondition> tileData(
      FilterQuery<ElementData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'tileData');
    });
  }
}

extension TileQueryLinks on QueryBuilder<Tile, Tile, QFilterCondition> {}

extension TileQuerySortBy on QueryBuilder<Tile, Tile, QSortBy> {
  QueryBuilder<Tile, Tile, QAfterSortBy> sortByColumnSpan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnSpan', Sort.asc);
    });
  }

  QueryBuilder<Tile, Tile, QAfterSortBy> sortByColumnSpanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnSpan', Sort.desc);
    });
  }

  QueryBuilder<Tile, Tile, QAfterSortBy> sortByRowSpan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rowSpan', Sort.asc);
    });
  }

  QueryBuilder<Tile, Tile, QAfterSortBy> sortByRowSpanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rowSpan', Sort.desc);
    });
  }
}

extension TileQuerySortThenBy on QueryBuilder<Tile, Tile, QSortThenBy> {
  QueryBuilder<Tile, Tile, QAfterSortBy> thenByColumnSpan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnSpan', Sort.asc);
    });
  }

  QueryBuilder<Tile, Tile, QAfterSortBy> thenByColumnSpanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'columnSpan', Sort.desc);
    });
  }

  QueryBuilder<Tile, Tile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Tile, Tile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Tile, Tile, QAfterSortBy> thenByRowSpan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rowSpan', Sort.asc);
    });
  }

  QueryBuilder<Tile, Tile, QAfterSortBy> thenByRowSpanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rowSpan', Sort.desc);
    });
  }
}

extension TileQueryWhereDistinct on QueryBuilder<Tile, Tile, QDistinct> {
  QueryBuilder<Tile, Tile, QDistinct> distinctByColumnSpan() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'columnSpan');
    });
  }

  QueryBuilder<Tile, Tile, QDistinct> distinctByRowSpan() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rowSpan');
    });
  }
}

extension TileQueryProperty on QueryBuilder<Tile, Tile, QQueryProperty> {
  QueryBuilder<Tile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Tile, int, QQueryOperations> columnSpanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'columnSpan');
    });
  }

  QueryBuilder<Tile, GlobalElementCoordinates, QQueryOperations>
      coordinatesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'coordinates');
    });
  }

  QueryBuilder<Tile, int, QQueryOperations> rowSpanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rowSpan');
    });
  }

  QueryBuilder<Tile, ElementData?, QQueryOperations> tileDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tileData');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const GlobalElementCoordinatesSchema = Schema(
  name: r'GlobalElementCoordinates',
  id: -6163868732312298790,
  properties: {
    r'column': PropertySchema(
      id: 0,
      name: r'column',
      type: IsarType.long,
    ),
    r'location': PropertySchema(
      id: 1,
      name: r'location',
      type: IsarType.byte,
      enumMap: _GlobalElementCoordinateslocationEnumValueMap,
    ),
    r'page': PropertySchema(
      id: 2,
      name: r'page',
      type: IsarType.long,
    ),
    r'row': PropertySchema(
      id: 3,
      name: r'row',
      type: IsarType.long,
    )
  },
  estimateSize: _globalElementCoordinatesEstimateSize,
  serialize: _globalElementCoordinatesSerialize,
  deserialize: _globalElementCoordinatesDeserialize,
  deserializeProp: _globalElementCoordinatesDeserializeProp,
);

int _globalElementCoordinatesEstimateSize(
  GlobalElementCoordinates object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _globalElementCoordinatesSerialize(
  GlobalElementCoordinates object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.column);
  writer.writeByte(offsets[1], object.location.index);
  writer.writeLong(offsets[2], object.page);
  writer.writeLong(offsets[3], object.row);
}

GlobalElementCoordinates _globalElementCoordinatesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GlobalElementCoordinates(
    column: reader.readLongOrNull(offsets[0]) ?? 0,
    location: _GlobalElementCoordinateslocationValueEnumMap[
            reader.readByteOrNull(offsets[1])] ??
        Location.list,
    page: reader.readLongOrNull(offsets[2]),
    row: reader.readLongOrNull(offsets[3]) ?? 0,
  );
  return object;
}

P _globalElementCoordinatesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (_GlobalElementCoordinateslocationValueEnumMap[
              reader.readByteOrNull(offset)] ??
          Location.list) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _GlobalElementCoordinateslocationEnumValueMap = {
  'list': 0,
  'dock': 1,
  'home': 2,
  'topDock': 3,
};
const _GlobalElementCoordinateslocationValueEnumMap = {
  0: Location.list,
  1: Location.dock,
  2: Location.home,
  3: Location.topDock,
};

extension GlobalElementCoordinatesQueryFilter on QueryBuilder<
    GlobalElementCoordinates, GlobalElementCoordinates, QFilterCondition> {
  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> columnEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'column',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> columnGreaterThan(
    int value, {
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

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> columnLessThan(
    int value, {
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

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> columnBetween(
    int lower,
    int upper, {
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

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> locationEqualTo(Location value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> locationGreaterThan(
    Location value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'location',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> locationLessThan(
    Location value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'location',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> locationBetween(
    Location lower,
    Location upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'location',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> pageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'page',
      ));
    });
  }

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> pageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'page',
      ));
    });
  }

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> pageEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'page',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> pageGreaterThan(
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

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> pageLessThan(
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

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> pageBetween(
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

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> rowEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'row',
        value: value,
      ));
    });
  }

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> rowGreaterThan(
    int value, {
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

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> rowLessThan(
    int value, {
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

  QueryBuilder<GlobalElementCoordinates, GlobalElementCoordinates,
      QAfterFilterCondition> rowBetween(
    int lower,
    int upper, {
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
}

extension GlobalElementCoordinatesQueryObject on QueryBuilder<
    GlobalElementCoordinates, GlobalElementCoordinates, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ElementDataSchema = Schema(
  name: r'ElementData',
  id: -89844720841365758,
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
    r'columnSpan': PropertySchema(
      id: 2,
      name: r'columnSpan',
      type: IsarType.long,
    ),
    r'origin': PropertySchema(
      id: 3,
      name: r'origin',
      type: IsarType.object,
      target: r'GlobalElementCoordinates',
    ),
    r'rowSpan': PropertySchema(
      id: 4,
      name: r'rowSpan',
      type: IsarType.long,
    )
  },
  estimateSize: _elementDataEstimateSize,
  serialize: _elementDataSerialize,
  deserialize: _elementDataDeserialize,
  deserializeProp: _elementDataDeserializeProp,
);

int _elementDataEstimateSize(
  ElementData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.appData;
    if (value != null) {
      bytesCount += 3 +
          AppDataSchema.estimateSize(value, allOffsets[AppData]!, allOffsets);
    }
  }
  {
    final value = object.appWidgetData;
    if (value != null) {
      bytesCount += 3 +
          AppWidgetDataSchema.estimateSize(
              value, allOffsets[AppWidgetData]!, allOffsets);
    }
  }
  bytesCount += 3 +
      GlobalElementCoordinatesSchema.estimateSize(
          object.origin, allOffsets[GlobalElementCoordinates]!, allOffsets);
  return bytesCount;
}

void _elementDataSerialize(
  ElementData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObject<AppData>(
    offsets[0],
    allOffsets,
    AppDataSchema.serialize,
    object.appData,
  );
  writer.writeObject<AppWidgetData>(
    offsets[1],
    allOffsets,
    AppWidgetDataSchema.serialize,
    object.appWidgetData,
  );
  writer.writeLong(offsets[2], object.columnSpan);
  writer.writeObject<GlobalElementCoordinates>(
    offsets[3],
    allOffsets,
    GlobalElementCoordinatesSchema.serialize,
    object.origin,
  );
  writer.writeLong(offsets[4], object.rowSpan);
}

ElementData _elementDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ElementData(
    appData: reader.readObjectOrNull<AppData>(
      offsets[0],
      AppDataSchema.deserialize,
      allOffsets,
    ),
    appWidgetData: reader.readObjectOrNull<AppWidgetData>(
      offsets[1],
      AppWidgetDataSchema.deserialize,
      allOffsets,
    ),
    columnSpan: reader.readLongOrNull(offsets[2]) ?? 1,
    origin: reader.readObjectOrNull<GlobalElementCoordinates>(
          offsets[3],
          GlobalElementCoordinatesSchema.deserialize,
          allOffsets,
        ) ??
        defaultCoordinates,
    rowSpan: reader.readLongOrNull(offsets[4]) ?? 1,
  );
  return object;
}

P _elementDataDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectOrNull<AppData>(
        offset,
        AppDataSchema.deserialize,
        allOffsets,
      )) as P;
    case 1:
      return (reader.readObjectOrNull<AppWidgetData>(
        offset,
        AppWidgetDataSchema.deserialize,
        allOffsets,
      )) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    case 3:
      return (reader.readObjectOrNull<GlobalElementCoordinates>(
            offset,
            GlobalElementCoordinatesSchema.deserialize,
            allOffsets,
          ) ??
          defaultCoordinates) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 1) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ElementDataQueryFilter
    on QueryBuilder<ElementData, ElementData, QFilterCondition> {
  QueryBuilder<ElementData, ElementData, QAfterFilterCondition>
      appDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'appData',
      ));
    });
  }

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition>
      appDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'appData',
      ));
    });
  }

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition>
      appWidgetDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'appWidgetData',
      ));
    });
  }

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition>
      appWidgetDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'appWidgetData',
      ));
    });
  }

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition>
      columnSpanEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'columnSpan',
        value: value,
      ));
    });
  }

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition>
      columnSpanGreaterThan(
    int value, {
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

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition>
      columnSpanLessThan(
    int value, {
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

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition>
      columnSpanBetween(
    int lower,
    int upper, {
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

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition> rowSpanEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rowSpan',
        value: value,
      ));
    });
  }

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition>
      rowSpanGreaterThan(
    int value, {
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

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition> rowSpanLessThan(
    int value, {
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

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition> rowSpanBetween(
    int lower,
    int upper, {
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

extension ElementDataQueryObject
    on QueryBuilder<ElementData, ElementData, QFilterCondition> {
  QueryBuilder<ElementData, ElementData, QAfterFilterCondition> appData(
      FilterQuery<AppData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'appData');
    });
  }

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition> appWidgetData(
      FilterQuery<AppWidgetData> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'appWidgetData');
    });
  }

  QueryBuilder<ElementData, ElementData, QAfterFilterCondition> origin(
      FilterQuery<GlobalElementCoordinates> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'origin');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

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
  AppData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.packageName.length * 3;
  return bytesCount;
}

void _appDataSerialize(
  AppData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.packageName);
}

AppData _appDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppData(
    packageName: reader.readStringOrNull(offsets[0]) ?? '',
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
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AppDataQueryFilter
    on QueryBuilder<AppData, AppData, QFilterCondition> {
  QueryBuilder<AppData, AppData, QAfterFilterCondition> packageNameEqualTo(
    String value, {
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

  QueryBuilder<AppData, AppData, QAfterFilterCondition> packageNameGreaterThan(
    String value, {
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

  QueryBuilder<AppData, AppData, QAfterFilterCondition> packageNameLessThan(
    String value, {
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

  QueryBuilder<AppData, AppData, QAfterFilterCondition> packageNameBetween(
    String lower,
    String upper, {
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

  QueryBuilder<AppData, AppData, QAfterFilterCondition> packageNameStartsWith(
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

  QueryBuilder<AppData, AppData, QAfterFilterCondition> packageNameEndsWith(
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

  QueryBuilder<AppData, AppData, QAfterFilterCondition> packageNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppData, AppData, QAfterFilterCondition> packageNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppData, AppData, QAfterFilterCondition> packageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<AppData, AppData, QAfterFilterCondition>
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
    on QueryBuilder<AppData, AppData, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

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
  AppWidgetData object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.componentName.length * 3;
  return bytesCount;
}

void _appWidgetDataSerialize(
  AppWidgetData object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.appWidgetId);
  writer.writeString(offsets[1], object.componentName);
}

AppWidgetData _appWidgetDataDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppWidgetData(
    appWidgetId: reader.readLongOrNull(offsets[0]),
    componentName: reader.readStringOrNull(offsets[1]) ?? '',
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
      return (reader.readStringOrNull(offset) ?? '') as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AppWidgetDataQueryFilter
    on QueryBuilder<AppWidgetData, AppWidgetData, QFilterCondition> {
  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      appWidgetIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'appWidgetId',
      ));
    });
  }

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      appWidgetIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'appWidgetId',
      ));
    });
  }

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      appWidgetIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'appWidgetId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      appWidgetIdGreaterThan(
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

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      appWidgetIdLessThan(
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

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      appWidgetIdBetween(
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

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      componentNameEqualTo(
    String value, {
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

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      componentNameGreaterThan(
    String value, {
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

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      componentNameLessThan(
    String value, {
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

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      componentNameBetween(
    String lower,
    String upper, {
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

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      componentNameStartsWith(
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

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      componentNameEndsWith(
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

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      componentNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'componentName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      componentNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'componentName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      componentNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'componentName',
        value: '',
      ));
    });
  }

  QueryBuilder<AppWidgetData, AppWidgetData, QAfterFilterCondition>
      componentNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'componentName',
        value: '',
      ));
    });
  }
}

extension AppWidgetDataQueryObject
    on QueryBuilder<AppWidgetData, AppWidgetData, QFilterCondition> {}
