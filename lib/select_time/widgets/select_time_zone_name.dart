import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instant/instant.dart';
import 'package:timezones/select_time/select_time.dart';

class SelectTimeZoneName extends StatelessWidget {
  const SelectTimeZoneName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SelectTimeBloc, SelectTimeState, String>(
      selector: (state) => state.timeZoneName,
      builder: (context, timeZoneName) {
        return GestureDetector(
          onTap: () async {
            final timeZoneNames = timeZoneOffsets.keys.toList()..sort();

            final bloc = context.read<SelectTimeBloc>();
            final result = await showModalBottomSheet<String?>(
              context: context,
              builder: (_) => ListView.builder(
                itemCount: timeZoneNames.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(timeZoneNames[index]),
                  onTap: () => Navigator.of(context).pop(timeZoneNames[index]),
                ),
              ),
            );
            if (result != null) {
              bloc.add(SelectTimeTimeZoneNameSelected(result));
            }
          },
          child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Text(
                    timeZoneName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ],
              )),
        );
      },
    );
  }
}
