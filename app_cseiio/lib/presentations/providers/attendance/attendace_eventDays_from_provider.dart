// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../inputs/datetime_input.dart';
import '../../inputs/name.dart';

class AttendaceEventdaysFromState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final bool isValidEvent;
  final bool isCheckingEvent;
  final bool isSumit;
  final Name name;
  final Name description;
  final DateTimeInput time;

  AttendaceEventdaysFromState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.isValidEvent = false,
    this.isCheckingEvent = false,
    this.isSumit = false,
    this.name = const Name.pure(),
    this.description = const Name.pure(),
    this.time = const DateTimeInput.pure(),
  });

  AttendaceEventdaysFromState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    bool? isValidEvent,
    bool? isCheckingEvent,
    bool? isSumit,
    Name? name,
    Name? description,
    DateTimeInput? time,
  }) {
    return AttendaceEventdaysFromState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      isValidEvent: isValidEvent ?? this.isValidEvent,
      isCheckingEvent: isCheckingEvent ?? this.isCheckingEvent,
      isSumit: isSumit ?? this.isSumit,
      name: name ?? this.name,
      description: description ?? this.description,
      time: time ?? this.time,
    );
  }

  @override
  String toString() {
    return '''
    isPosting: $isPosting, 
    isFormPosted: $isFormPosted, 
    isValid: $isValid, 
    isValidEvent: $isValidEvent, 
    isCheckingEvent: $isCheckingEvent, 
    isSumit: $isSumit, 
    name: $name, 
    description: $description, 
    time: $time
    ''';
  }
}
