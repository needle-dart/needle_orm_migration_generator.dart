Needle ORM for dart.

Try to be a familar ORM framework to java programmers, so it will obey jakarta.persistence spec.

annotations supported status:

- [x] @Entity
- [ ] @Column
- [ ] @Transient
- [ ] @Table
- [ ] @ID
- [ ] @Lob
- [ ] @OneToOne
- [ ] @OneToMany
- [ ] @ManyToOne
- [ ] @ManyToMany
- [ ] @Index
- [ ] @OrderBy
- [ ] @Version
- [ ] @SoftDelete

the following annotations can NOT be supported directly, but are supported in @Entity :

- @PreInsert
- @PreUpdate
- @PreDelete
- @PostInsert
- @PostUpdate
- @PostDelete
- @PostLoad

## Define Model

```dart
@Entity()
abstract class _BaseModel {
  @ID()
  int? _id;

  @Version()
  int? _version;

  @SoftDelete()
  bool? _deleted;

  @WhenCreated()
  DateTime? _createdAt;

  @WhenModified()
  DateTime? _updatedAt;

  @WhoCreated()
  String? _createdBy; // user login name

  @WhoModified()
  String? _lastUpdatedBy; // user login name

  @Column()
  String? _remark;

  _BaseModel();
}

@Table(name: 'tbl_user')
@Entity(prePersist: 'beforeInsert', postPersist: 'afterInsert')
class _User extends _BaseModel {
  @Column()
  String? _name;

  @Column()
  String? _loginName;

  @Column()
  String? _address;

  @Column()
  int? _age;

  _User();
}
```

## Enhance business logic

```dart
extension Biz_User on User {
  bool isAdmin() {
    return name!.startsWith('admin');
  }

  // @override
  void beforeInsert() {
    _version = 1;
    _deleted = false;
    print('before insert user ....');
  }

  void afterInsert() {
    print('after insert user ....');
  }
}
```

## Usage

```dart
void main() {
  var user = User();
  user
    ..name = 'administrator'
    ..address = 'abc'
    ..age = 23
    ..save(); // insert

  user
    ..id = 100
    ..save(); // update because id is set.

  // call business method
  print('is admin? ${user.isAdmin()}');
  print('user.toMap() : ${user.toMap()}');

  // load data from a map
  user.loadMap({"name": 'admin123', "xxxx": 'xxxx'});

  var book = Book();
  book
    ..author = user
    ..title = 'Dart'
    ..insert();
}

```
