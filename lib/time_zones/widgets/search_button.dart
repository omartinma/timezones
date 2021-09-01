import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezones/search/search.dart';
import 'package:timezones/time_zones/time_zones.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () async {
        final bloc = context.read<TimeZonesBloc>();
        final query = await Navigator.of(context).push(SearchPage.route());
        if (query != null) {
          bloc.add(TimeZonesAddRequested(city: query));
        }
      },
      child: const Icon(Icons.search),
    );
  }
}
