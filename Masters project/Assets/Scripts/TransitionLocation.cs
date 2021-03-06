﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransitionLocation : MonoBehaviour
{
    public GameObject obj;
    public GameObject objBelow;

    public Transform start, end;

    public bool isIgnored = false;
    public bool transitionOnEnter = false;

    void Awake()
    {
        
        start = transform.GetChild(1);
        end = transform.GetChild(2);
    }

    void Start()
    {
        TransitionHandler.instance.transitionEvent += OnTransition;
    }

    void OnDrawGizmos()
    {
        Gizmos.DrawWireSphere(start.position, 0.1f);
        Gizmos.DrawWireSphere(end.position, 0.1f);
    }

    void OnTransition()
    {
        isIgnored = !isIgnored;
        obj.layer = isIgnored ? 11 : 9;
    }
}
