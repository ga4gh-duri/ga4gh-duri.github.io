#!/usr/bin/perl

=pod

=cut

use File::Basename;
use File::Copy;
use YAML::XS qw(LoadFile DumpFile);
use Data::Dumper;

binmode STDOUT, ":utf8";

my @cat_blocks  =   qw(General Products);

my $here_path   =   File::Basename::dirname( eval { ( caller() )[1] } );
my $base_path   =   $here_path.'/..';
our $config     =   LoadFile($base_path.'/_config.yml') or die "¡No _config.yml file in this path!";

foreach my $type (qw(tags categories)) {

  my @items;
  my $template  =   $base_path.'/_templates/'.$type.'.md';
  my $type_path =   $base_path.'/'.$type;
  
  if ($type eq 'tags') {
    @items      =   @{ $config->{cloud_tags} } }
  elsif  ($type eq 'categories') {
    foreach $cat_block (keys %{ $config->{nav_cat_blocks} }) {
      if ($config->{nav_cat_blocks}->{$cat_block} =~ /\,$type\,/) {
        push(
         @items,
         keys %{ $config->{$cat_block} },
        );
      }
    }
  }
  
  mkdir $type_path;
  foreach (@items) { copy($template, $type_path.'/'.$_.'.md') }
  foreach (@items) { print $type_path.'/'.$_.'.md'."\n" }

}

mkdir $base_path.'/'.$config->{collections_dir};
foreach my $coll (keys %{ $config->{collections} }) {
  mkdir $base_path.'/'.$config->{collections_dir}.'/_'.$coll;
  print $base_path.'/'.$config->{collections_dir}.'/_'.$coll."\n";
}

