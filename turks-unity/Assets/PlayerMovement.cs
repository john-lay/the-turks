using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

enum Direction
{
    None = 0,
    Down,
    Right,
    Up,
    Left
}

public class PlayerMovement : MonoBehaviour
{
    public float moveSpeed = 5f;

    public Rigidbody2D rb;

    public Animator animator;

    Vector2 movement;

    // input logic
    void Update()
    {
        movement.x = Input.GetAxisRaw("Horizontal");
        movement.y = Input.GetAxisRaw("Vertical");

        PreventDiagonalMovement();

        animator.SetFloat("Horizontal", movement.x);
        animator.SetFloat("Vertical", movement.y);
        animator.SetFloat("Speed", movement.sqrMagnitude);

        if (movement.y > 0) animator.SetInteger("Direction", (int) Direction.Up);
        if (movement.y < 0) animator.SetInteger("Direction", (int) Direction.Down);
        if (movement.x < 0) animator.SetInteger("Direction", (int) Direction.Left);
        if (movement.x > 0) animator.SetInteger("Direction", (int) Direction.Right);
    }

    private void PreventDiagonalMovement()
    {
        if (Mathf.Abs(movement.x) > Mathf.Abs(movement.y))
        {
            movement.y = 0;
        }
        else
        {
            movement.x = 0;
        }
    }

    // movement and physics logic
    private void FixedUpdate()
    {
        rb.MovePosition(rb.position + movement * (moveSpeed * Time.fixedDeltaTime));
    }
}