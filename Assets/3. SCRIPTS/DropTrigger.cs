using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DropTrigger : MonoBehaviour
{
    [SerializeField] private Transform backPoint;

    private void OnTriggerEnter(Collider other)
    {
        if(other.name == "DropTrigger")
        {
            GetComponent<Transform>().position = backPoint.position;
        }
    }
}
