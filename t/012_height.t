#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 74;

my $CLASS = 'Tree';
use_ok( $CLASS );

{ # test height (with pictures)

    my $D = $CLASS->new();
    isa_ok($D, 'Tree');

    #   |
    #  <D>

    cmp_ok($D->height(), '==', 1, '... D has a height of 1');

    my $E = $CLASS->new();
    isa_ok($E, 'Tree');

    $D->add_child($E);

    #   |
    #  <D>
    #    \
    #    <E>

    cmp_ok($D->height(), '==', 2, '... D has a height of 2');
    cmp_ok($E->height(), '==', 1, '... E has a height of 1');

    my $F = $CLASS->new();
    isa_ok($F, 'Tree');

    $E->add_child($F);

    #   |
    #  <D>
    #    \
    #    <E>
    #      \
    #      <F>

    cmp_ok($D->height(), '==', 3, '... D has a height of 3');
    cmp_ok($E->height(), '==', 2, '... E has a height of 2');
    cmp_ok($F->height(), '==', 1, '... F has a height of 1');

    my $C = $CLASS->new();
    isa_ok($C, 'Tree');

    $D->add_child($C);

    #    |
    #   <D>
    #   / \
    # <C> <E>
    #       \
    #       <F>

    cmp_ok($D->height(), '==', 3, '... D has a height of 3');
    cmp_ok($E->height(), '==', 2, '... E has a height of 2');
    cmp_ok($F->height(), '==', 1, '... F has a height of 1');
    cmp_ok($C->height(), '==', 1, '... C has a height of 1');

    my $B = $CLASS->new();
    isa_ok($B, 'Tree');

    $C->add_child($B);

    #      |
    #     <D>
    #     / \
    #   <C> <E>
    #   /     \
    # <B>     <F>


    cmp_ok($D->height(), '==', 3, '... D has a height of 3');
    cmp_ok($E->height(), '==', 2, '... E has a height of 2');
    cmp_ok($F->height(), '==', 1, '... F has a height of 1');
    cmp_ok($C->height(), '==', 2, '... C has a height of 2');
    cmp_ok($B->height(), '==', 1, '... B has a height of 1');

    my $A = $CLASS->new();
    isa_ok($A, 'Tree');

    $B->add_child($A);

    #        |
    #       <D>
    #       / \
    #     <C> <E>
    #     /     \
    #   <B>     <F>
    #   /         
    # <A>         

    cmp_ok($D->height(), '==', 4, '... D has a height of 4');
    cmp_ok($E->height(), '==', 2, '... E has a height of 2');
    cmp_ok($F->height(), '==', 1, '... F has a height of 1');
    cmp_ok($C->height(), '==', 3, '... C has a height of 3');
    cmp_ok($B->height(), '==', 2, '... B has a height of 2');
    cmp_ok($A->height(), '==', 1, '... A has a height of 1');

    my $G = $CLASS->new();
    isa_ok($G, 'Tree');

    $E->add_child( at => 0, $G);

    #        |
    #       <D>
    #       / \
    #     <C> <E>
    #     /   / \
    #   <B> <G> <F>
    #   /         
    # <A>         

    cmp_ok($D->height(), '==', 4, '... D has a height of 4');
    cmp_ok($E->height(), '==', 2, '... E has a height of 2');
    cmp_ok($F->height(), '==', 1, '... F has a height of 1');
    cmp_ok($G->height(), '==', 1, '... G has a height of 1');
    cmp_ok($C->height(), '==', 3, '... C has a height of 3');
    cmp_ok($B->height(), '==', 2, '... B has a height of 2');
    cmp_ok($A->height(), '==', 1, '... A has a height of 1');

    my $H = $CLASS->new();
    isa_ok($H, 'Tree');

    $G->add_child($H);

    #        |
    #       <D>
    #       / \
    #     <C> <E>
    #     /   / \
    #   <B> <G> <F>
    #   /     \    
    # <A>     <H>    

    cmp_ok($D->height(), '==', 4, '... D has a height of 4');
    cmp_ok($E->height(), '==', 3, '... E has a height of 3');
    cmp_ok($F->height(), '==', 1, '... F has a height of 1');
    cmp_ok($G->height(), '==', 2, '... G has a height of 2');
    cmp_ok($H->height(), '==', 1, '... H has a height of 1');
    cmp_ok($C->height(), '==', 3, '... C has a height of 3');
    cmp_ok($B->height(), '==', 2, '... B has a height of 2');
    cmp_ok($A->height(), '==', 1, '... A has a height of 1');

    cmp_ok($D->depth(), '==', 0, '... D has a depth of 0');
    cmp_ok($E->depth(), '==', 1, '... E has a depth of 1');
    cmp_ok($F->depth(), '==', 2, '... F has a depth of 2');
    cmp_ok($G->depth(), '==', 2, '... G has a depth of 2');
    cmp_ok($H->depth(), '==', 3, '... H has a depth of 3');
    cmp_ok($C->depth(), '==', 1, '... C has a depth of 1');
    cmp_ok($B->depth(), '==', 2, '... B has a depth of 2');
    cmp_ok($A->depth(), '==', 3, '... A has a depth of 3');

    ok($B->remove_child($A), '... removed A subtree from B tree');

    #        |
    #       <D>
    #       / \
    #     <C> <E>
    #     /   / \
    #   <B> <G> <F>
    #         \    
    #         <H> 

    cmp_ok($D->height(), '==', 4, '... D has a height of 4');
    cmp_ok($E->height(), '==', 3, '... E has a height of 3');
    cmp_ok($F->height(), '==', 1, '... F has a height of 1');
    cmp_ok($G->height(), '==', 2, '... G has a height of 2');
    cmp_ok($H->height(), '==', 1, '... H has a height of 1');
    cmp_ok($C->height(), '==', 2, '... C has a height of 2');
    cmp_ok($B->height(), '==', 1, '... B has a height of 1');

    # and the removed tree is ok
    cmp_ok($A->height(), '==', 1, '... A has a height of 1');

    ok($D->remove_child($E), '... removed E subtree from D tree');

    #        |
    #       <D>
    #       / 
    #     <C> 
    #     /     
    #   <B>

    cmp_ok($D->height(), '==', 3, '... D has a height of 3');
    cmp_ok($C->height(), '==', 2, '... C has a height of 2');
    cmp_ok($B->height(), '==', 1, '... B has a height of 1');

    # and the removed trees are ok
    cmp_ok($E->height(), '==', 3, '... E has a height of 3');
    cmp_ok($F->height(), '==', 1, '... F has a height of 1');
    cmp_ok($G->height(), '==', 2, '... G has a height of 2');
    cmp_ok($H->height(), '==', 1, '... H has a height of 1');    

    ok($D->remove_child($C), '... removed C subtree from D tree');

    #        |
    #       <D>

    cmp_ok($D->height(), '==', 1, '... D has a height of 1');

    # and the removed tree is ok
    cmp_ok($C->height(), '==', 2, '... C has a height of 2');
    cmp_ok($B->height(), '==', 1, '... B has a height of 1');      
}