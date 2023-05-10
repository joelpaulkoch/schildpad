// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_counter.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPageCounterCollection on Isar {
  IsarCollection<PageCounter> get pageCounters => this.collection();
}

const PageCounterSchema = CollectionSchema(
  name: r'PageCounter',
  id: 3677538755186946072,
  properties: {
    r'leftPages': PropertySchema(
      id: 0,
      name: r'leftPages',
      type: IsarType.long,
    ),
    r'rightPages': PropertySchema(
      id: 1,
      name: r'rightPages',
      type: IsarType.long,
    )
  },
  estimateSize: _pageCounterEstimateSize,
  serialize: _pageCounterSerialize,
  deserialize: _pageCounterDeserialize,
  deserializeProp: _pageCounterDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _pageCounterGetId,
  getLinks: _pageCounterGetLinks,
  attach: _pageCounterAttach,
  version: '3.1.0+1',
);

int _pageCounterEstimateSize(
  PageCounter object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _pageCounterSerialize(
  PageCounter object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.leftPages);
  writer.writeLong(offsets[1], object.rightPages);
}

PageCounter _pageCounterDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PageCounter(
    leftPages: reader.readLongOrNull(offsets[0]) ?? 0,
    rightPages: reader.readLongOrNull(offsets[1]) ?? 0,
  );
  object.id = id;
  return object;
}

P _pageCounterDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pageCounterGetId(PageCounter object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pageCounterGetLinks(PageCounter object) {
  return [];
}

void _pageCounterAttach(
    IsarCollection<dynamic> col, Id id, PageCounter object) {
  object.id = id;
}

extension PageCounterQueryWhereSort
    on QueryBuilder<PageCounter, PageCounter, QWhere> {
  QueryBuilder<PageCounter, PageCounter, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PageCounterQueryWhere
    on QueryBuilder<PageCounter, PageCounter, QWhereClause> {
  QueryBuilder<PageCounter, PageCounter, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PageCounter, PageCounter, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterWhereClause> idBetween(
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

extension PageCounterQueryFilter
    on QueryBuilder<PageCounter, PageCounter, QFilterCondition> {
  QueryBuilder<PageCounter, PageCounter, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PageCounter, PageCounter, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PageCounter, PageCounter, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PageCounter, PageCounter, QAfterFilterCondition>
      leftPagesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leftPages',
        value: value,
      ));
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterFilterCondition>
      leftPagesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leftPages',
        value: value,
      ));
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterFilterCondition>
      leftPagesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leftPages',
        value: value,
      ));
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterFilterCondition>
      leftPagesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leftPages',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterFilterCondition>
      rightPagesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rightPages',
        value: value,
      ));
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterFilterCondition>
      rightPagesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rightPages',
        value: value,
      ));
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterFilterCondition>
      rightPagesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rightPages',
        value: value,
      ));
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterFilterCondition>
      rightPagesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rightPages',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PageCounterQueryObject
    on QueryBuilder<PageCounter, PageCounter, QFilterCondition> {}

extension PageCounterQueryLinks
    on QueryBuilder<PageCounter, PageCounter, QFilterCondition> {}

extension PageCounterQuerySortBy
    on QueryBuilder<PageCounter, PageCounter, QSortBy> {
  QueryBuilder<PageCounter, PageCounter, QAfterSortBy> sortByLeftPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leftPages', Sort.asc);
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterSortBy> sortByLeftPagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leftPages', Sort.desc);
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterSortBy> sortByRightPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rightPages', Sort.asc);
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterSortBy> sortByRightPagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rightPages', Sort.desc);
    });
  }
}

extension PageCounterQuerySortThenBy
    on QueryBuilder<PageCounter, PageCounter, QSortThenBy> {
  QueryBuilder<PageCounter, PageCounter, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterSortBy> thenByLeftPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leftPages', Sort.asc);
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterSortBy> thenByLeftPagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leftPages', Sort.desc);
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterSortBy> thenByRightPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rightPages', Sort.asc);
    });
  }

  QueryBuilder<PageCounter, PageCounter, QAfterSortBy> thenByRightPagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rightPages', Sort.desc);
    });
  }
}

extension PageCounterQueryWhereDistinct
    on QueryBuilder<PageCounter, PageCounter, QDistinct> {
  QueryBuilder<PageCounter, PageCounter, QDistinct> distinctByLeftPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leftPages');
    });
  }

  QueryBuilder<PageCounter, PageCounter, QDistinct> distinctByRightPages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rightPages');
    });
  }
}

extension PageCounterQueryProperty
    on QueryBuilder<PageCounter, PageCounter, QQueryProperty> {
  QueryBuilder<PageCounter, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PageCounter, int, QQueryOperations> leftPagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leftPages');
    });
  }

  QueryBuilder<PageCounter, int, QQueryOperations> rightPagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rightPages');
    });
  }
}
