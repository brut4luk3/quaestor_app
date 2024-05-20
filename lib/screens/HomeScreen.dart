import 'package:flutter/material.dart';
import '../utils/api.dart';
import '../blocs/names_bloc.dart';
import '../blocs/names_event.dart';
import '../blocs/names_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';
import 'DetailsScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NamesBloc(api: Api())..add(LoadNamesEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nomes mais frequentes"),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {},
            )
          ],
        ),
        body: const Center(
          child: NamesList(),
        ),
      ),
    );
  }
}

class NamesList extends StatefulWidget {
  const NamesList({super.key});

  @override
  _NamesListState createState() => _NamesListState();
}

class _NamesListState extends State<NamesList> {
  int _currentPage = 0;
  final int _itemsPerPage = 6;
  String _searchQuery = '';
  late List<dynamic> _allNames;
  late List<dynamic> _filteredNames;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allNames = [];
    _filteredNames = [];
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
      _filteredNames = Api().searchNames(query, _allNames);
      _currentPage = 0; // Reset to the first page
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _filteredNames = Api().searchNames(_searchQuery, _allNames);
      _currentPage = 0; // Reset to the first page
    });
  }

  Future<void> _navigateToDetails(BuildContext context, String name, int rank) async {
    final nameDetails = await Api().fetchNameDetails(name);
    if (nameDetails.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsScreen(
            nameDetails: nameDetails,
            rank: rank,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 60, top: 50),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Busque por nomes',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSearch,
              )
                  : null,
            ),
            onChanged: _handleSearch,
          ),
        ),
        Expanded(
          child: BlocBuilder<NamesBloc, NamesState>(
            builder: (context, state) {
              if (state is NamesLoading) {
                return const CircularProgressIndicator();
              } else if (state is NamesLoaded) {
                _allNames = state.names;
                _filteredNames = Api().searchNames(_searchQuery, _allNames);

                if (_filteredNames.isEmpty) {
                  return const Center(
                    child: Text("Este nome não foi incluído no Censo ainda..."),
                  );
                }

                final totalPages = (_filteredNames.length / _itemsPerPage).ceil();
                final startIndex = _currentPage * _itemsPerPage;
                final endIndex = (startIndex + _itemsPerPage).clamp(0, _filteredNames.length);
                final namesToDisplay = _filteredNames.sublist(startIndex, endIndex);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: namesToDisplay.length,
                        itemBuilder: (context, index) {
                          final name = namesToDisplay[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                            child: Card(
                              color: const Color(0xFF848484),
                              child: ListTile(
                                title: Text(
                                  name['nome'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  'Posição no rank: ${name['rank']}º',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                onTap: () => _navigateToDetails(context, name['nome'], name['rank']),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (totalPages > 1)
                      NumberPaginator(
                        numberPages: totalPages,
                        initialPage: _currentPage,
                        onPageChange: (int index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        config: const NumberPaginatorUIConfig(
                          buttonSelectedBackgroundColor: Colors.green,
                          buttonSelectedForegroundColor: Colors.white,
                          buttonUnselectedForegroundColor: Colors.black,
                          buttonShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      ),
                  ],
                );
              } else if (state is NamesError) {
                return const Text('Erro ao carregar nomes');
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}