import 'package:flutter_test/flutter_test.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_cubit.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_state.dart';

void main() {
  const a = Place(id: 'a', name: 'A', zone: 'z', isPopular: true);
  const b = Place(id: 'b', name: 'B', zone: 'z', isPopular: true);

  test('la recherche demande deux lieux différents', () {
    final cubit = SearchFormCubit();
    expect(cubit.state.canSearch, isFalse);

    cubit.setPlace(SearchField.from, a);
    expect(cubit.state.canSearch, isFalse);

    cubit.setPlace(SearchField.to, a);
    expect(cubit.state.samePlace, isTrue);
    expect(cubit.state.canSearch, isFalse);

    cubit.setPlace(SearchField.to, b);
    expect(cubit.state.canSearch, isTrue);
  });

  test('un repère remplit le départ puis l’arrivée', () {
    final cubit = SearchFormCubit();
    cubit.fillNextEmpty(a);
    cubit.fillNextEmpty(b);
    expect(cubit.state.departure, a);
    expect(cubit.state.arrival, b);
  });
}
