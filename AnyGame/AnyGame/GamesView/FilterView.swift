//
//  FilterView.swift
//  AnyGame
//
//  Created by Alper Görler on 12.07.24.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: GamesViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Genres")) {
                    ForEach(viewModel.genres) { genre in
                        HStack {
                            Text(genre.name)
                            Spacer()
                            if viewModel.selectedGenres.contains(where: { $0.id == genre.id }) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let index = viewModel.selectedGenres.firstIndex(where: { $0.id == genre.id }) {
                                viewModel.selectedGenres.remove(at: index)
                            } else {
                                viewModel.selectedGenres.append(genre)
                            }
                        }
                    }
                }

                Section(header: Text("Platforms")) {
                    ForEach(viewModel.platforms) { platform in
                        HStack {
                            Text(platform.name)
                            Spacer()
                            if viewModel.selectedPlatforms.contains(where: { $0.id == platform.id }) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let index = viewModel.selectedPlatforms.firstIndex(where: { $0.id == platform.id }) {
                                viewModel.selectedPlatforms.remove(at: index)
                            } else {
                                viewModel.selectedPlatforms.append(platform)
                            }
                        }
                    }
                }

                Section(header: Text("Publishers")) {
                    ForEach(viewModel.publishers) { publisher in
                        HStack {
                            Text(publisher.name)
                            Spacer()
                            if viewModel.selectedPublishers.contains(where: { $0.id == publisher.id }) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let index = viewModel.selectedPublishers.firstIndex(where: { $0.id == publisher.id }) {
                                viewModel.selectedPublishers.remove(at: index)
                            } else {
                                viewModel.selectedPublishers.append(publisher)
                            }
                        }
                    }
                }

                Section(header: Text("Tags")) {
                    ForEach(viewModel.tags) { tag in
                        HStack {
                            Text(tag.name)
                            Spacer()
                            if viewModel.selectedTags.contains(where: { $0.id == tag.id }) {
                                Image(systemName: "checkmark")
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let index = viewModel.selectedTags.firstIndex(where: { $0.id == tag.id }) {
                                viewModel.selectedTags.remove(at: index)
                            } else {
                                viewModel.selectedTags.append(tag)
                            }
                        }
                    }
                }

                Button(action: {
                    viewModel.applyFilters()
                }) {
                    Text("Apply Filters")
                        .foregroundStyle(Color.red)
                }
            }
            .navigationTitle("Filter")
            .onAppear {
                viewModel.fetchGenres()
                viewModel.fetchPlatforms()
                viewModel.fetchPublishers()
                viewModel.fetchTags()
            }
        }
    }
}

#Preview {
    FilterView(viewModel: GamesViewModel())
}





